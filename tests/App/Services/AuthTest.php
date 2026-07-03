<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\User;
use App\Utils\Hash;
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;
use PHPUnit\Framework\TestCase;
use ReflectionClass;

final class AuthTest extends TestCase
{
    protected Capsule $capsule;

    protected function setUp(): void
    {
        $_ENV['key'] = 'test_key';
        $_ENV['pwdMethod'] = 'bcrypt';
        $_ENV['enable_login_bind_ip'] = false;
        $_ENV['enable_login_bind_device'] = false;

        $_COOKIE = [];
        $this->resetAuthStaticState();

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
        });
    }

    protected function tearDown(): void
    {
        $this->resetAuthStaticState();
        $_COOKIE = [];
    }

    private function resetAuthStaticState(): void
    {
        $reflection = new ReflectionClass(Auth::class);

        foreach (['user', 'server', 'cookies'] as $property) {
            $prop = $reflection->getProperty($property);
            $prop->setValue(null, $property === 'user' ? null : []);
        }
    }

    public function testLoginUsesRequestContextAndRetrievesUser(): void
    {
        $user = User::create([
            'email' => 'test@example.com',
            'pass' => Hash::passwordHash('password'),
            'ga_enable' => 0,
        ]);

        $server = [
            'HTTP_HOST' => 'localhost',
            'REMOTE_ADDR' => '127.0.0.1',
            'HTTP_USER_AGENT' => 'unit-test-agent',
        ];

        Auth::setRequestContext($server, []);
        Auth::login($user->id, 3600);

        $loggedUser = Auth::getUser($server, $_COOKIE);

        $this->assertTrue($loggedUser->isLogin);
        $this->assertSame($user->id, $loggedUser->id);
        $this->assertSame('test@example.com', $loggedUser->email);
    }

    public function testLogoutClearsCookieValues(): void
    {
        $server = [
            'HTTP_HOST' => 'localhost',
            'REMOTE_ADDR' => '127.0.0.1',
            'HTTP_USER_AGENT' => 'unit-test-agent',
        ];

        $_COOKIE = [
            'uid' => '1',
            'email' => 'test@example.com',
            'key' => 'abc',
            'ip' => 'hash',
            'device' => 'device',
            'expire_in' => '3600',
        ];

        Auth::logout($server);

        $this->assertSame('', $_COOKIE['uid']);
        $this->assertSame('', $_COOKIE['email']);
        $this->assertSame('', $_COOKIE['key']);
        $this->assertSame('', $_COOKIE['ip']);
        $this->assertSame('', $_COOKIE['device']);
        $this->assertSame('', $_COOKIE['expire_in']);
    }
}
