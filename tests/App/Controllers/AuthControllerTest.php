<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\Config;
use App\Models\User;
use App\Services\Auth;
use GuzzleHttp\Psr7\HttpFactory;
use GuzzleHttp\Psr7\ServerRequest as PsrServerRequest;
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;
use PHPUnit\Framework\TestCase;
use Slim\Http\Factory\DecoratedResponseFactory;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class AuthControllerTest extends TestCase
{
    protected Capsule $capsule;

    protected function setUp(): void
    {
        $_ENV['pwdMethod'] = 'bcrypt';
        $_ENV['key'] = 'test_key';
        $_ENV['rememberMeDuration'] = '7';
        $_ENV['enable_login_bind_ip'] = false;
        $_ENV['enable_login_bind_device'] = false;

        $this->capsule = new Capsule();
        $this->capsule->addConnection([
            'driver' => 'sqlite',
            'database' => ':memory:',
        ]);
        $this->capsule->setAsGlobal();
        $this->capsule->bootEloquent();

        $this->capsule->schema()->create('config', static function (Blueprint $table): void {
            $table->increments('id');
            $table->string('item');
            $table->string('value');
            $table->string('class')->default('');
            $table->string('is_public')->default('0');
            $table->string('type')->default('string');
            $table->string('mark')->default('');
        });

        $this->capsule->schema()->create('user', static function (Blueprint $table): void {
            $table->increments('id');
            $table->string('email');
            $table->string('pass');
            $table->tinyInteger('ga_enable')->default(0);
            $table->integer('last_login_time')->default(0);
        });

        $this->capsule->schema()->create('login_ip', static function (Blueprint $table): void {
            $table->increments('id');
            $table->integer('userid')->default(0);
            $table->string('ip')->nullable();
            $table->integer('datetime')->default(0);
            $table->tinyInteger('type')->default(0);
        });

        Config::create([
            'item' => 'enable_login_captcha',
            'value' => '0',
            'type' => 'bool',
        ]);
        Config::create([
            'item' => 'login_log',
            'value' => '0',
            'type' => 'bool',
        ]);
        Config::create([
            'item' => 'rememberMeDuration',
            'value' => '7',
            'type' => 'int',
        ]);
    }

    public function testLoginHandleRedirectsOnValidCredentials(): void
    {
        User::create([
            'email' => 'test@example.com',
            'pass' => password_hash('password', PASSWORD_BCRYPT),
            'ga_enable' => 0,
        ]);

        $psrRequest = new PsrServerRequest('POST', '/auth/login', ['User-Agent' => 'phpunit'], null, '1.1', ['REMOTE_ADDR' => '127.0.0.1']);
        $request = (new ServerRequest($psrRequest))
            ->withParsedBody([
                'email' => 'test@example.com',
                'password' => 'password',
                'remember_me' => 'false',
            ])
            ->withCookieParams([]);

        $guzzleFactory = new HttpFactory();
        $responseFactory = new DecoratedResponseFactory($guzzleFactory, $guzzleFactory);
        $response = $responseFactory->createResponse();
        $controller = new AuthController();

        $result = $controller->loginHandle($request, $response, []);

        $this->assertSame('/user', $result->getHeaderLine('HX-Redirect'));
    }

    public function testLoginHandleReturnsErrorOnBadPassword(): void
    {
        User::create([
            'email' => 'test@example.com',
            'pass' => password_hash('password', PASSWORD_BCRYPT),
            'ga_enable' => 0,
        ]);

        $psrRequest = new PsrServerRequest('POST', '/auth/login', ['User-Agent' => 'phpunit'], null, '1.1', ['REMOTE_ADDR' => '127.0.0.1']);
        $request = (new ServerRequest($psrRequest))
            ->withParsedBody([
                'email' => 'test@example.com',
                'password' => 'wrong',
                'remember_me' => 'false',
            ])
            ->withCookieParams([]);

        $guzzleFactory = new HttpFactory();
        $responseFactory = new DecoratedResponseFactory($guzzleFactory, $guzzleFactory);
        $response = $responseFactory->createResponse();
        $controller = new AuthController();

        $result = $controller->loginHandle($request, $response, []);

        $body = json_decode((string) $result->getBody(), true);
        $this->assertSame(0, $body['ret']);
        $this->assertSame('邮箱或者密码错误', $body['msg']);
    }
}
