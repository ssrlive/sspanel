<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Link;
use App\Models\Node;
use App\Models\User;
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;
use PHPUnit\Framework\TestCase;

final class SubscribeTest extends TestCase
{
    protected Capsule $capsule;

    protected function setUp(): void
    {
        $_ENV['subUrl'] = 'http://localhost';

        $this->capsule = new Capsule();
        $this->capsule->addConnection([
            'driver' => 'sqlite',
            'database' => ':memory:',
        ]);
        $this->capsule->setAsGlobal();
        $this->capsule->bootEloquent();

        $this->capsule->schema()->create('link', static function (Blueprint $table): void {
            $table->increments('id');
            $table->integer('userid');
            $table->string('token');
        });

        $this->capsule->schema()->create('node', static function (Blueprint $table): void {
            $table->increments('id');
            $table->integer('type');
            $table->integer('node_class');
            $table->integer('node_group');
            $table->integer('node_bandwidth_limit');
            $table->integer('node_bandwidth');
            $table->string('name');
            $table->integer('online');
            $table->integer('node_speedlimit');
            $table->integer('gfw_block');
            $table->string('server')->default('127.0.0.1');
        });

        $this->capsule->schema()->create('user', static function (Blueprint $table): void {
            $table->increments('id');
            $table->string('email');
            $table->string('user_name')->default('');
            $table->integer('class')->default(0);
            $table->integer('node_group')->default(0);
            $table->integer('is_admin')->default(0);
            $table->integer('transfer_enable')->default(0);
            $table->integer('u')->default(0);
            $table->integer('d')->default(0);
            $table->string('class_expire')->default('');
        });
    }

    public function testGetUniversalSubLinkCreatesToken(): void
    {
        $user = User::create([
            'email' => 'test@example.com',
            'user_name' => 'test',
            'class' => 0,
            'node_group' => 0,
            'is_admin' => 0,
            'transfer_enable' => 0,
            'u' => 0,
            'd' => 0,
            'class_expire' => '2026-01-01',
        ]);

        $link = Subscribe::getUniversalSubLink($user);

        $this->assertStringStartsWith('http://localhost/sub/', $link);
        $this->assertSame(1, Link::query()->where('userid', $user->id)->count());
    }

    public function testGetUserNodesRespectsClassAndGroup(): void
    {
        $user = User::create([
            'email' => 'test@example.com',
            'user_name' => 'test',
            'class' => 1,
            'node_group' => 0,
            'is_admin' => 0,
            'transfer_enable' => 0,
            'u' => 0,
            'd' => 0,
            'class_expire' => '2026-01-01',
        ]);

        Node::create([
            'type' => 1,
            'node_class' => 1,
            'node_group' => 0,
            'node_bandwidth_limit' => 0,
            'node_bandwidth' => 0,
            'name' => 'node1',
            'online' => 1,
            'node_speedlimit' => 0,
            'gfw_block' => 0,
            'server' => '127.0.0.1',
        ]);

        $nodes = Subscribe::getUserNodes($user);

        $this->assertCount(1, $nodes);
        $this->assertSame('node1', $nodes->first()->name);
    }
}
