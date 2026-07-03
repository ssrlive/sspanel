<?php

/**
 * SSPanel-Uim Public Entrance File
 *
 * @license MIT(https://github.com/Anankke/SSPanel-Uim/blob/dev/LICENSE)
 *          Addition: You shouldn't remove staff page or entrance of that page.
 */

declare(strict_types=1);

require_once __DIR__ . '/../app/predefine.php';
require_once BASE_PATH . '/vendor/autoload.php';
require_once BASE_PATH . '/config/.config.php';
require_once BASE_PATH . '/config/appprofile.php';

use App\Middleware\ErrorHandler;
use App\Services\Auth;
use App\Services\Boot;
use GuzzleHttp\Psr7\HttpFactory;
use GuzzleHttp\Psr7\ServerRequest;
use Slim\Factory\AppFactory;
use Slim\Http\Factory\DecoratedResponseFactory;

Boot::setTime();
Boot::bootSentry();
Boot::bootDb();

$guzzle_factory = new HttpFactory();
$response_factory = new DecoratedResponseFactory($guzzle_factory, $guzzle_factory);
$app = AppFactory::create($response_factory);

$app->add(new ErrorHandler());

$routes = require BASE_PATH . '/app/routes.php';
$routes($app);

$request = ServerRequest::fromGlobals();
$request = new Slim\Http\ServerRequest($request);
Auth::setRequestContext($request->getServerParams(), $request->getCookieParams());

$app->run($request);
