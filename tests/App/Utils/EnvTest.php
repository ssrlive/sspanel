<?php

declare(strict_types=1);

namespace App\Utils;

use PHPUnit\Framework\TestCase;

class EnvTest extends TestCase
{
    public function testGetReturnsDefaultWhenMissing(): void
    {
        unset($_ENV['TEST_ENV_MISSING']);

        $this->assertNull(Env::get('TEST_ENV_MISSING'));
        $this->assertSame('default', Env::getString('TEST_ENV_MISSING', 'default'));
        $this->assertSame(42, Env::getInt('TEST_ENV_MISSING', 42));
        $this->assertFalse(Env::getBool('TEST_ENV_MISSING', false));
        $this->assertSame(['a', 'b'], Env::getArray('TEST_ENV_MISSING', ['a', 'b']));
    }

    public function testGetCastingMethods(): void
    {
        $_ENV['TEST_ENV_STR'] = 'hello';
        $_ENV['TEST_ENV_INT'] = '123';
        $_ENV['TEST_ENV_BOOL_TRUE'] = 'true';
        $_ENV['TEST_ENV_BOOL_FALSE'] = '0';
        $_ENV['TEST_ENV_ARRAY'] = '["x", "y"]';

        $this->assertSame('hello', Env::getString('TEST_ENV_STR', 'default'));
        $this->assertSame(123, Env::getInt('TEST_ENV_INT', 0));
        $this->assertTrue(Env::getBool('TEST_ENV_BOOL_TRUE', false));
        $this->assertFalse(Env::getBool('TEST_ENV_BOOL_FALSE', true));
        $this->assertSame(['x', 'y'], Env::getArray('TEST_ENV_ARRAY', []));
    }
}
