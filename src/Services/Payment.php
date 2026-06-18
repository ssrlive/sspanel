<?php

declare(strict_types=1);

namespace App\Services;

use App\Services\Gateway\Base;
use App\Utils\ClassHelper;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class Payment
{
    public static function getAllPaymentMap(): array
    {
        $payments = [];

        $helper = new ClassHelper();
        $class_list = $helper->getClassesByNamespace('\\App\\Services\\Gateway\\');

        foreach ($class_list as $class) {
            if (get_parent_class($class) === 'App\\Services\\Gateway\\Base') {
                $payments[] = $class;
            }
        }

        return $payments;
    }

    public static function getPaymentsEnabled(): array
    {
        return array_values(array_filter(Payment::getAllPaymentMap(), static function ($payment) {
            return $payment::_enable();
        }));
    }

    public static function getPaymentMap(): array
    {
        $result = [];

        foreach (self::getPaymentsEnabled() as $payment) {
            $result[$payment::_name()] = $payment;
        }

        return $result;
    }

    public static function getPaymentByName(string $name): ?string
    {
        $all = self::getPaymentMap();

        return $all[$name] ?? null;
    }

    public static function notify(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        if (! isset($args['type'])) {
            return $response->withStatus(404);
        }

        $payment = self::getPaymentByName($args['type']);

        if ($payment !== null && is_a($payment, Base::class, true)) {
            $instance = new $payment();
            return $instance->notify($request, $response, $args);
        }

        return $response->withStatus(404);
    }

    public static function returnHTML(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        if (! isset($args['type'])) {
            return $response->withStatus(404);
        }

        $payment = self::getPaymentByName($args['type']);

        if ($payment !== null && is_a($payment, Base::class, true)) {
            $instance = new $payment();
            return $instance->getReturnHTML($request, $response, $args);
        }

        return $response->withStatus(404);
    }

    public static function purchase(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        if (! isset($args['type'])) {
            return $response->withStatus(404);
        }

        $payment = self::getPaymentByName($args['type']);

        if ($payment !== null && is_a($payment, Base::class, true)) {
            $instance = new $payment();
            return $instance->purchase($request, $response, $args);
        }

        return $response->withStatus(404);
    }
}
