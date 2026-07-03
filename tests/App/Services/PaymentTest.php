<?php

declare(strict_types=1);

namespace App\Services;

use GuzzleHttp\Psr7\HttpFactory;
use GuzzleHttp\Psr7\ServerRequest as PsrServerRequest;
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;
use PHPUnit\Framework\TestCase;
use Slim\Http\Factory\DecoratedResponseFactory;
use Slim\Http\ServerRequest;

final class PaymentTest extends TestCase
{
    protected Capsule $capsule;

    protected function setUp(): void
    {
        $this->capsule = new Capsule();
        $this->capsule->addConnection([
            'driver' => 'sqlite',
            'database' => ':memory:',
        ]);
        $this->capsule->setAsGlobal();
        $this->capsule->bootEloquent();
    }

    public function testNotifyReturns404WhenMissingType(): void
    {
        $psrRequest = new PsrServerRequest('POST', '/payment/notify', [], null, '1.1', ['REMOTE_ADDR' => '127.0.0.1']);
        $request = new ServerRequest($psrRequest);
        $guzzleFactory = new HttpFactory();
        $responseFactory = new DecoratedResponseFactory($guzzleFactory, $guzzleFactory);
        $response = $responseFactory->createResponse();

        $result = Payment::notify($request, $response, []);

        $this->assertSame(404, $result->getStatusCode());
    }
}
