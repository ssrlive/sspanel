<?php

declare(strict_types=1);

namespace App\Middleware;

use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class NodeApi
{
    /**
     * MID /node/api
     */
    public function __invoke(ServerRequest $request, Response $response, callable $next): ResponseInterface
    {
        return $next($request, $response);
    }
}
