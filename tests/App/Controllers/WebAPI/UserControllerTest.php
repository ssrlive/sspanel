<?php

declare(strict_types=1);

namespace App\Controllers\WebAPI;

use GuzzleHttp\Psr7\HttpFactory;
use GuzzleHttp\Psr7\ServerRequest as PsrServerRequest;
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;
use PHPUnit\Framework\TestCase;
use ReflectionClass;
use Slim\Http\Factory\DecoratedResponseFactory;
use Slim\Http\ServerRequest;

use function json_decode;
use function json_encode;

final class UserControllerTest extends TestCase
{
    private Capsule $capsule;

    protected function setUp(): void
    {
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
            $table->string('type')->default('string');
        });

        $this->capsule->schema()->create('node', static function (Blueprint $table): void {
            $table->increments('id');
            $table->integer('type');
            $table->boolean('is_dynamic_rate')->default(false);
            $table->integer('dynamic_rate_type')->default(0);
            $table->text('dynamic_rate_config')->nullable();
            $table->float('traffic_rate')->default(1);
            $table->integer('node_bandwidth')->default(0);
            $table->integer('online_user')->default(0);
        });

        $this->capsule->schema()->create('user', static function (Blueprint $table): void {
            $table->increments('id');
            $table->string('uuid')->unique();
            $table->integer('last_use_time')->default(0);
            $table->integer('u')->default(0);
            $table->integer('d')->default(0);
            $table->integer('transfer_total')->default(0);
            $table->integer('transfer_today')->default(0);
        });

        $this->capsule->schema()->create('panel_traffic_report', static function (Blueprint $table): void {
            $table->unsignedBigInteger('node_id');
            $table->string('reporter_id', 36);
            $table->unsignedBigInteger('last_sequence')->default(0);
            $table->primary(['node_id', 'reporter_id']);
        });

        $this->capsule->table('node')->insert(['id' => 1, 'type' => 1]);
        $this->capsule->table('user')->insert([
            'id' => 10,
            'uuid' => 'f2d46ca2-8d6d-4c5c-ae77-80c902ce68d7',
        ]);
    }

    public function testTrafficReportSequenceIsAppliedOnlyOnce(): void
    {
        $controller = (new ReflectionClass(UserController::class))->newInstanceWithoutConstructor();
        $report = [
            'reporter_id' => 'f2d46ca2-8d6d-4c5c-ae77-80c902ce68d7',
            'sequence' => 1,
            'data' => [[
                'client_id' => 'f2d46ca2-8d6d-4c5c-ae77-80c902ce68d7',
                'u' => 2,
                'd' => 3,
            ]],
        ];

        $this->assertSame(1, $this->sendTraffic($controller, $report));
        $this->assertSame(1, $this->sendTraffic($controller, $report));

        $nextReport = $report;
        $nextReport['sequence'] = 2;
        $nextReport['data'][0]['u'] = 5;
        $nextReport['data'][0]['d'] = 7;
        $this->assertSame(1, $this->sendTraffic($controller, $nextReport));

        $legacyReport = [
            'data' => [[
                'client_id' => 'f2d46ca2-8d6d-4c5c-ae77-80c902ce68d7',
                'u' => 1,
                'd' => 1,
            ]],
        ];
        $this->assertSame(1, $this->sendTraffic($controller, $legacyReport));

        $user = $this->capsule->table('user')->where('id', 10)->first();
        $node = $this->capsule->table('node')->where('id', 1)->first();
        $this->assertSame(8, (int) $user->u);
        $this->assertSame(11, (int) $user->d);
        $this->assertSame(19, (int) $user->transfer_total);
        $this->assertSame(19, (int) $user->transfer_today);
        $this->assertSame(19, (int) $node->node_bandwidth);
        $this->assertSame(1, (int) $node->online_user);
    }

    private function sendTraffic(UserController $controller, array $report): int
    {
        $psrRequest = new PsrServerRequest(
            'POST',
            '/mod_mu/users/traffic',
            [],
            json_encode($report)
        );
        $request = (new ServerRequest($psrRequest))->withQueryParams(['node_id' => 1]);
        $factory = new HttpFactory();
        $response = (new DecoratedResponseFactory($factory, $factory))->createResponse();

        $result = $controller->addTraffic($request, $response, []);
        $body = json_decode((string) $result->getBody(), true);

        return (int) $body['ret'];
    }
}
