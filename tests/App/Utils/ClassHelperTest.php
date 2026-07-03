<?php

declare(strict_types=1);

namespace App\Utils;

use PHPUnit\Framework\TestCase;

final class ClassHelperTest extends TestCase
{
    private ClassHelper $classHelper;

    protected function setUp(): void
    {
        $this->classHelper = new ClassHelper();
    }

    public function testGetClassesByNamespace(): void
    {
        $namespace = 'App\\Utils';
        $classes = $this->classHelper->getClassesByNamespace($namespace);

        $this->assertIsArray($classes);
        $this->assertContains('\App\Utils\ClassHelper', $classes);
    }

    public function testGetClasses(): void
    {
        $classes = $this->classHelper->getClasses();

        $this->assertIsArray($classes);
        $this->assertContains('\App\Utils\ClassHelper', $classes);
    }
}
