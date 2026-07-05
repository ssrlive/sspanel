<?php

declare(strict_types=1);

namespace App\Middleware;

use App\Services\Auth as AuthService;
use App\Services\View;
use App\Utils\Env;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Slim\CallableResolver;
use Slim\Exception\HttpMethodNotAllowedException;
use Slim\Exception\HttpNotFoundException;
use Slim\Factory\AppFactory;
use Slim\Handlers\ErrorHandler as SlimErrorHandler;
use Throwable;
use function Sentry\captureException;

final class ErrorHandler implements MiddlewareInterface
{
    /**
     * @throws Exception
     */
    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        try {
            $user = AuthService::getUser();
            $path = $request->getUri()->getPath();

            if (str_contains($path, '/admin') && ! $user->is_admin) {
                $response_factory = AppFactory::determineResponseFactory();
                $response = $response_factory->createResponse(302);

                if ($user->isLogin) {
                    return $response->withHeader('Location', '/user');
                }

                return $response->withHeader('Location', '/auth/login');
            }

            $response = $handler->handle($request);
        } catch (HttpNotFoundException | HttpMethodNotAllowedException $e) {
            // 404 or 405 thrown by router
            $code = $e->getCode();
            $response_factory = AppFactory::determineResponseFactory();
            $response = $response_factory->createResponse($code);
            $smarty = View::getSmarty();
            $response->getBody()->write($smarty->fetch("{$code}.tpl"));
            $response = $response->withStatus($code);
        } catch (Throwable $e) {
            $response_factory = AppFactory::determineResponseFactory();

            error_log(
                sprintf(
                    "[%s] %s: %s in %s on line %d\n%s",
                    date('c'),
                    $e::class,
                    $e->getMessage(),
                    $e->getFile(),
                    $e->getLine(),
                    $e->getTraceAsString()
                )
            );

            if (Env::get('sentry_dsn') !== '') {
                captureException($e);
            }

            if (Env::get('debug')) {
                $callable_resolver = new CallableResolver(null);
                $error_handler = new SlimErrorHandler($callable_resolver, $response_factory);
                $response = $error_handler($request, $e, true, true, false);
            } else {
                $response = $response_factory->createResponse(500);
                $smarty = View::getSmarty();
                $response->getBody()->write($smarty->fetch('500.tpl'));
            }
        }

        return $response;
    }
}
