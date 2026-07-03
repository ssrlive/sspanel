<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Config;
use App\Models\Invoice;
use App\Models\User;
use App\Services\Gateway\Epay;
use GuzzleHttp\Psr7\HttpFactory;
use GuzzleHttp\Psr7\ServerRequest as PsrServerRequest;
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;
use PHPUnit\Framework\TestCase;
use Slim\Http\Factory\DecoratedResponseFactory;
use Slim\Http\ServerRequest;

final class EpayPurchaseTest extends TestCase
{
    protected Capsule $capsule;

    protected function setUp(): void
    {
        $_ENV['epay_url'] = 'https://example.com/';
        $_ENV['epay_pid'] = 'pid';
        $_ENV['epay_key'] = 'secret';
        $_ENV['epay_sign_type'] = 'sha256';
        $_ENV['appName'] = 'TestApp';
        $_ENV['baseUrl'] = 'http://localhost';

        $this->capsule = new Capsule();
        $this->capsule->addConnection([
            'driver' => 'sqlite',
            'database' => ':memory:',
        ]);
        $this->capsule->setAsGlobal();
        $this->capsule->bootEloquent();

        $this->capsule->schema()->create('user', static function (Blueprint $table): void {
            $table->increments('id');
            $table->string('email');
            $table->string('pass');
            $table->tinyInteger('ga_enable')->default(0);
            $table->integer('money')->default(0);
            $table->integer('ref_by')->default(0);
        });

        $this->capsule->schema()->create('invoice', static function (Blueprint $table): void {
            $table->increments('id');
            $table->string('type')->default('product');
            $table->integer('user_id');
            $table->string('order_id')->default('');
            $table->string('content')->default('');
            $table->float('price');
            $table->string('status')->default('unpaid');
            $table->integer('create_time')->default(0);
            $table->integer('update_time')->default(0);
            $table->integer('pay_time')->default(0);
        });

        $this->capsule->schema()->create('config', static function (Blueprint $table): void {
            $table->increments('id');
            $table->string('item');
            $table->string('value');
            $table->string('class')->default('');
            $table->string('is_public')->default('0');
            $table->string('type')->default('string');
            $table->string('default')->default('');
            $table->string('mark')->default('');
        });

        $this->capsule->schema()->create('paylist', static function (Blueprint $table): void {
            $table->increments('id');
            $table->integer('userid');
            $table->float('total');
            $table->integer('invoice_id');
            $table->string('tradeno');
            $table->string('gateway')->default('');
            $table->integer('status')->default(0);
            $table->integer('datetime')->default(0);
        });

        Config::create([
            'item' => 'epay_url',
            'value' => 'https://example.com/',
            'type' => 'string',
        ]);
        Config::create([
            'item' => 'epay_pid',
            'value' => 'pid',
            'type' => 'string',
        ]);
        Config::create([
            'item' => 'epay_key',
            'value' => 'secret',
            'type' => 'string',
        ]);
        Config::create([
            'item' => 'epay_sign_type',
            'value' => 'sha256',
            'type' => 'string',
        ]);
    }

    public function testPurchaseReturnsErrorWhenInvoiceMissing(): void
    {
        $psrRequest = new PsrServerRequest('POST', '/payment/purchase', [], null, '1.1', ['REMOTE_ADDR' => '127.0.0.1']);
        $request = (new ServerRequest($psrRequest))
            ->withParsedBody(['invoice_id' => '999', 'type' => 'alipay', 'redir' => 'http://localhost/return'])
            ->withCookieParams([]);

        $guzzleFactory = new HttpFactory();
        $responseFactory = new DecoratedResponseFactory($guzzleFactory, $guzzleFactory);
        $response = $responseFactory->createResponse();

        $epay = new Epay();
        $result = $epay->purchase($request, $response, []);

        $body = json_decode((string) $result->getBody(), true);

        $this->assertSame(200, $result->getStatusCode());
        $this->assertSame(0, $body['ret']);
        $this->assertSame('Invoice not found', $body['msg']);
    }

    public function testPurchaseReturnsErrorWhenPriceIsNotPositive(): void
    {
        $user = User::create([
            'email' => 'test@example.com',
            'pass' => password_hash('password', PASSWORD_BCRYPT),
            'ga_enable' => 0,
            'money' => 0,
            'ref_by' => 0,
        ]);

        $invoice = Invoice::create([
            'type' => 'product',
            'user_id' => $user->id,
            'order_id' => 'order-1',
            'content' => '[]',
            'price' => 0,
            'status' => 'unpaid',
            'create_time' => time(),
            'update_time' => time(),
            'pay_time' => 0,
        ]);

        $psrRequest = new PsrServerRequest('POST', '/payment/purchase', [], null, '1.1', ['REMOTE_ADDR' => '127.0.0.1']);
        $request = (new ServerRequest($psrRequest))
            ->withParsedBody(['invoice_id' => (string) $invoice->id, 'type' => 'alipay', 'redir' => 'http://localhost/return'])
            ->withCookieParams([]);

        $guzzleFactory = new HttpFactory();
        $responseFactory = new DecoratedResponseFactory($guzzleFactory, $guzzleFactory);
        $response = $responseFactory->createResponse();

        $epay = new Epay();
        $result = $epay->purchase($request, $response, []);

        $body = json_decode((string) $result->getBody(), true);

        $this->assertSame(200, $result->getStatusCode());
        $this->assertSame(0, $body['ret']);
        $this->assertSame('非法的金额', $body['msg']);
    }
}
