<?php

declare(strict_types=1);

namespace App\Services\Subscribe;

use App\Models\User;

abstract class Base
{
    abstract public function getContent(User $user): string;
}
