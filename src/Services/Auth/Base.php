<?php

declare(strict_types=1);

namespace App\Services\Auth;

use App\Models\User;

abstract class Base
{
    abstract public function login(int $uid, int $time, array $server = [], array $cookies = []): void;

    abstract public function getUser(array $server = [], array $cookies = []): User;

    abstract public function logout(array $server = []): void;
}
