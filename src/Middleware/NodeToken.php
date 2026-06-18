<?php

declare(strict_types=1);

namespace App\Middleware;

use App\Models\Node;
use App\Services\RateLimit;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use RedisException;
use Slim\Factory\AppFactory;
use Slim\Http\Response;
use voku\helper\AntiXSS;

final class NodeToken implements MiddlewareInterface
{
    /**
     * @throws RedisException
     */
    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        $key = $request->getQueryParams()['key'] ?? null;

        if ($key === null) {
            /** @var Response $response */
            $response = AppFactory::determineResponseFactory()->createResponse(401);
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Invalid request.',
            ]);
        }

        $antiXss = new AntiXSS();

        if (
            $_ENV['enable_rate_limit'] &&
            (! (new RateLimit())->checkRateLimit('webapi_ip', $request->getServerParams()['REMOTE_ADDR'] ?? '') ||
                ! (new RateLimit())->checkRateLimit('webapi_key', $antiXss->xss_clean($key)))
        ) {
            /** @var Response $response */
            $response = AppFactory::determineResponseFactory()->createResponse(401);
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Invalid request.',
            ]);
        }

        if (
            ! $_ENV['webAPI'] ||
            $key !== $_ENV['muKey'] ||
            'https://' . $request->getHeaderLine('Host') !== $_ENV['webAPIUrl']
        ) {
            /** @var Response $response */
            $response = AppFactory::determineResponseFactory()->createResponse(401);
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Invalid request.',
            ]);
        }

        if ($_ENV['checkNodeIp']) {
            $ip = $request->getServerParams()['REMOTE_ADDR'] ?? '';

            if (
                $ip !== '127.0.0.1' && $ip !== '::1' && $ip !== '0:0:0:0:0:0:0:1' &&
                ! (new Node())->where('ipv4', $ip)->orWhere('ipv6', $ip)->exists()
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
}
