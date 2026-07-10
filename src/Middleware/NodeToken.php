<?php

declare(strict_types=1);

namespace App\Middleware;

use App\Models\Node;
use App\Services\Cache;
use App\Services\RateLimit;
use App\Utils\Env;
use App\Utils\Tools;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Redis;
use RedisException;
use Slim\Factory\AppFactory;
use Slim\Http\Response;
use voku\helper\AntiXSS;
use function dns_get_record;
use function parse_url;
use const DNS_A;
use const DNS_AAAA;

final class NodeToken implements MiddlewareInterface
{
    /**
     * @throws RedisException
     */
    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        $params = $request->getQueryParams();
        $key = $params['key'] ?? null;
        $node_id = $params['node_id'] ?? null;
        $peer_ip = $request->getServerParams()['REMOTE_ADDR'] ?? '';

        if ($key === null) {
            /** @var Response $response */
            $response = AppFactory::determineResponseFactory()->createResponse(401);
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Invalid request.',
            ]);
        }

        if (! is_string($node_id) && ! is_int($node_id) && ! ctype_digit((string) $node_id)) {
            /** @var Response $response */
            $response = AppFactory::determineResponseFactory()->createResponse(401);
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Invalid node id.',
            ]);
        }

        $antiXss = new AntiXSS();

        if (
            Env::get('enable_rate_limit') &&
            (! (new RateLimit())->checkRateLimit('webapi_ip', $peer_ip) ||
                ! (new RateLimit())->checkRateLimit('webapi_key', $antiXss->xss_clean($key)))
        ) {
            /** @var Response $response */
            $response = AppFactory::determineResponseFactory()->createResponse(401);
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Invalid request.',
            ]);
        }

        $requestScheme = $request->getUri()->getScheme();
        $requestScheme = $requestScheme ? $requestScheme : 'https';
        $requestWebApiUrl = $this->normalizeUrl($requestScheme . '://' . trim($request->getHeaderLine('Host'), '/'));
        $configuredWebApiUrl = $this->normalizeUrl((string) Env::get('webAPIUrl'));

        $node = (new Node())->find((int) $node_id);
        if ($node === null) {
            /** @var Response $response */
            $response = AppFactory::determineResponseFactory()->createResponse(401);
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Invalid node id.',
            ]);
        }

        $storedKey = $node->password;

        if (
            ! Env::get('webAPI') ||
            $key !== $storedKey ||
            $requestWebApiUrl !== $configuredWebApiUrl
        ) {
            /** @var Response $response */
            $response = AppFactory::determineResponseFactory()->createResponse(401);
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Invalid request.',
            ]);
        }

        if (Env::get('checkNodeIp')) {
            if (
                $peer_ip !== '127.0.0.1' && $peer_ip !== '::1' && $peer_ip !== '0:0:0:0:0:0:0:1' &&
                ! $this->isIpAllowedForServer($peer_ip, $node->server)
            ) {
                /** @var Response $response */
                $response = AppFactory::determineResponseFactory()->createResponse(401);
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'Invalid request IP.',
                ]);
            }
        }

        return $handler->handle($request);
    }

    private function normalizeUrl(string $url): string
    {
        $parsed = parse_url($url);
        if ($parsed === false) {
            return rtrim($url, '/');
        }

        $scheme = $parsed['scheme'] ?? 'https';
        $host = $parsed['host'] ?? '';
        $port = isset($parsed['port']) ? ':' . $parsed['port'] : '';

        return strtolower($scheme) . '://' . strtolower($host) . $port;
    }

    private function isIpAllowedForServer(string $ip, string $server): bool
    {
        $host = $this->normalizeServerHost($server);
        $cacheKey = $this->getNodeTokenCacheKey($host, $ip);

        $redis = $this->initRedis();
        if ($redis !== null) {
            try {
                $cached = $redis->get($cacheKey);
                if ($cached !== false) {
                    return $cached === '1';
                }
            } catch (RedisException $e) {
                $this->ignoreRedisException($e);
            }
        }

        $normalizedPeerIp = $this->normalizeIp($ip);
        $normalizedHost = $this->normalizeIp($host);

        if ($normalizedPeerIp !== null && $normalizedHost !== null && $normalizedPeerIp === $normalizedHost) {
            $this->saveNodeTokenCache($redis, $cacheKey, true);
            return true;
        }

        if (Tools::isIPv4($host) || Tools::isIPv6($host)) {
            $this->saveNodeTokenCache($redis, $cacheKey, false);
            return false;
        }

        try {
            $records = dns_get_record($host, DNS_A + DNS_AAAA);
        } catch (\Exception $e) {
            $this->saveNodeTokenCache($redis, $cacheKey, false);
            return false;
        }

        foreach ($records as $record) {
            if ($record['type'] === 'A' && $normalizedPeerIp !== null) {
                $recordIp = $this->normalizeIp($record['ip']);
                if ($recordIp !== null && $recordIp === $normalizedPeerIp) {
                    $this->saveNodeTokenCache($redis, $cacheKey, true);
                    return true;
                }
            }

            if ($record['type'] === 'AAAA' && $normalizedPeerIp !== null) {
                $recordIp = $this->normalizeIp($record['ipv6']);
                if ($recordIp !== null && $recordIp === $normalizedPeerIp) {
                    $this->saveNodeTokenCache($redis, $cacheKey, true);
                    return true;
                }
            }
        }

        $this->saveNodeTokenCache($redis, $cacheKey, false);
        return false;
    }

    private function initRedis(): ?Redis
    {
        try {
            return (new Cache())->initRedis();
        } catch (RedisException) {
            return null;
        }
    }

    private function getNodeTokenCacheKey(string $server, string $ip): string
    {
        return 'node_token_allowed:' . md5($server . '|' . $ip);
    }

    private function saveNodeTokenCache(?Redis $redis, string $cacheKey, bool $allowed): void
    {
        if ($redis === null) {
            return;
        }

        // Node reports every ~10 seconds, so keep DNS/IP cache short but not too short.
        // 120 seconds can significantly reduce repeated checks while still allowing for relatively quick detection of node IP/domain changes.
        $ttl = 120;

        try {
            $redis->setex($cacheKey, $ttl, $allowed ? '1' : '0');
        } catch (RedisException $e) {
            $this->ignoreRedisException($e);
        }
    }

    private function ignoreRedisException(RedisException $e): void
    {
        // Redis is an optional performance cache for NodeToken.
        // If Redis fails, continue without caching.
    }

    private function normalizeIp(string $ip): ?string
    {
        $ip = preg_replace('/%.+$/', '', $ip);
        if (! filter_var($ip, FILTER_VALIDATE_IP)) {
            return null;
        }

        $packed = inet_pton($ip);
        if ($packed === false) {
            return null;
        }

        return inet_ntop($packed);
    }

    private function normalizeServerHost(string $server): string
    {
        $server = trim($server);

        if (str_contains($server, '://')) {
            $parsed = parse_url($server);
            if ($parsed !== false && isset($parsed['host']) && $parsed['host'] !== '') {
                return $this->normalizeHost($parsed['host']);
            }
        }

        if (str_starts_with($server, '[')) {
            if (preg_match('/^\[([^\]]+)\](?::\d+)?$/', $server, $matches)) {
                return $this->normalizeHost($matches[1]);
            }
        }

        if (preg_match('/^(.+?):(\d+)$/', $server, $matches)) {
            return $this->normalizeHost($matches[1]);
        }

        return $this->normalizeHost($server);
    }

    private function normalizeHost(string $host): string
    {
        return strtolower(trim($host, " \t\n\r\0\x0B[]"));
    }
}
