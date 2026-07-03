<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Config;
use App\Services\Gateway\Epay\EpayNotify;
use App\Services\Gateway\Epay\EpayTool;
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;
use PHPUnit\Framework\TestCase;

final class EpayNotifyTest extends TestCase
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

        $this->capsule->schema()->create('config', static function (Blueprint $table): void {
            $table->increments('id');
            $table->string('item');
            $table->string('value');
            $table->string('class')->default('');
            $table->string('is_public')->default('0');
            $table->string('type')->default('string');
            $table->string('mark')->default('');
        });

        Config::create([
            'item' => 'epay_sign_type',
            'value' => 'sha256',
            'type' => 'string',
        ]);
    }

    public function testVerifyNotifyReturnsFalseWhenParamsInvalid(): void
    {
        $notify = new EpayNotify(['key' => 'secret']);

        $this->assertFalse($notify->verifyNotify([]));
        $this->assertFalse($notify->verifyNotify(['foo' => 'bar']));
    }

    public function testVerifyNotifyReturnsTrueForValidSignature(): void
    {
        $params = [
            'amount' => '100',
            'order_id' => '1',
            'sign_type' => 'RSA',
        ];
        $params['sign'] = EpayTool::sign(EpayTool::createLinkstring(EpayTool::argSort(EpayTool::paraFilter($params))), 'secret');

        $notify = new EpayNotify(['key' => 'secret']);
        $this->assertTrue($notify->verifyNotify($params));
    }
}
