<?php

declare(strict_types=1);

namespace App\Middleware;

use App\Models\Node;
use App\Services\RateLimit;
use App\Utils\Env;
use App\Utils\Tools;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
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

        if ($ip === $host) {
            return true;
        }

        if (Tools::isIPv4($host) || Tools::isIPv6($host)) {
            return false;
        }

        try {
            $records = dns_get_record($host, DNS_A + DNS_AAAA);
        } catch (\Exception $e) {
            return false;
        }

        foreach ($records as $record) {
            if (($record['type'] === 'A' && $record['ip'] === $ip) ||
                ($record['type'] === 'AAAA' && $record['ipv6'] === $ip)
            ) {
                return true;
            }
        }

        return false;
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
