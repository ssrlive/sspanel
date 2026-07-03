<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\User;
use App\Services\Auth\Cookie as AuthCookie;
use App\Utils\Cookie as CookieUtils;
use App\Utils\Env;
use App\Utils\Hash;
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;
use PHPUnit\Framework\TestCase;

final class AuthCookieTest extends TestCase
{
    protected Capsule $capsule;

    protected function setUp(): void
    {
        $_ENV['key'] = 'test_key';
        $_ENV['pwdMethod'] = 'bcrypt';
        $_ENV['enable_login_bind_ip'] = false;
        $_ENV['enable_login_bind_device'] = false;

        $_COOKIE = [];

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
        });
    }

    public function testLoginCreatesCookieAndGetUserWorks(): void
    {
        $user = User::create([
            'email' => 'test@example.com',
            'pass' => Hash::passwordHash('password'),
        ]);

        $server = [
            'HTTP_HOST' => 'localhost',
            'REMOTE_ADDR' => '127.0.0.1',
            'HTTP_USER_AGENT' => 'unit-test-agent',
        ];

        $authCookie = new AuthCookie();
        $authCookie->login($user->id, 3600, $server);

        $this->assertSame((string) $user->id, $_COOKIE['uid']);
        $this->assertSame('test@example.com', $_COOKIE['email']);
        $this->assertNotEmpty($_COOKIE['key']);
        $this->assertMatchesRegularExpression('/^\d+$/', $_COOKIE['expire_in']);
        $this->assertGreaterThan(time(), (int) $_COOKIE['expire_in']);

        $loggedUser = $authCookie->getUser($server, $_COOKIE);

        $this->assertTrue($loggedUser->isLogin);
        $this->assertSame($user->id, $loggedUser->id);
        $this->assertSame('test@example.com', $loggedUser->email);
    }

    public function testLogoutClearsCookieValues(): void
    {
        $_COOKIE = [
            'uid' => '1',
            'email' => 'test@example.com',
            'key' => 'abc',
            'ip' => 'xyz',
            'device' => 'ua',
            'expire_in' => '3600',
        ];

        $server = [
            'HTTP_HOST' => 'localhost',
            'REMOTE_ADDR' => '127.0.0.1',
            'HTTP_USER_AGENT' => 'unit-test-agent',
        ];

        $authCookie = new AuthCookie();
        $authCookie->logout($server);

        $this->assertSame('', CookieUtils::get('uid', $_COOKIE));
        $this->assertSame('', CookieUtils::get('email', $_COOKIE));
        $this->assertSame('', CookieUtils::get('key', $_COOKIE));
    }
}
