<?php

declare(strict_types=1);

namespace App\Services;

use PHPUnit\Framework\TestCase;
use Symfony\Component\Translation\Translator;

require_once __DIR__ . '/../../../app/predefine.php';

final class I18nTest extends TestCase
{
    public function testTrans(): void
    {
        // exsisting locale
        $key = 'lang_name';
        $lang = 'en_US';
        $expectedTranslation = 'English(Simplified)';

        $translation = I18n::trans($key, $lang);

        $this->assertSame($expectedTranslation, $translation);
        // non-existing locale
        $key = 'non_existent_key';

        $translation = I18n::trans($key, $lang);

        $this->assertSame($key, $translation);
    }

    public function testGetLocaleList(): void
    {
        $expectedLocales = ['en_US', 'ja_JP', 'zh_CN', 'zh_TW'];

        $locales = I18n::getLocaleList();

        $this->assertSame($expectedLocales, $locales);
    }

    public function testGetTranslatorr(): void
    {
        $lang = 'en_US';

        $translator = I18n::getTranslator($lang);

        $this->assertInstanceOf(Translator::class, $translator);
        $this->assertSame($lang, $translator->getLocale());
    }
}
