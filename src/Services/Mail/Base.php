<?php

declare(strict_types=1);

namespace App\Services\Mail;

abstract class Base
{
    abstract public function send(string $to, string $subject, string $body): void;
}
