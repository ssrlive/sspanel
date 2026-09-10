<?php

declare(strict_types=1);

namespace App\Services;

use Symfony\Component\Translation\Loader\PhpFileLoader;
use Symfony\Component\Translation\Translator;
use function basename;
use function glob;
use const BASE_PATH;

final class I18n
{
    // trans() right is human right 🏳️‍⚧️
    public static function trans(string $key, mixed $lang = 'en_US', array $parameters = []): string
    {
        $translator = self::getTranslator($lang);

        return $translator->trans($key, $parameters);
    }

    public static function getLocaleList(): array
    {
        $locales = [];
        $files = glob(BASE_PATH . '/resources/locale/*.php');

        foreach ($files as $file) {
            $locales[] = basename($file, '.php');
        }

        return $locales;
    }

    public static function getLocaleOptions(): array
    {
        $options = [];

        foreach (self::getLocaleList() as $locale) {
            $options[] = [
                'code' => $locale,
                'name' => self::trans('lang_name', $locale),
            ];
        }

        return $options;
    }

    public static function getTranslator(mixed $lang = 'en_US'): Translator
    {
        if (! is_string($lang) || ! in_array($lang, self::getLocaleList(), true)) {
            $lang = 'en_US';
        }

        $translator = new Translator($lang);
        $translator->addLoader('php', new PhpFileLoader());
        $translator->setFallbackLocales(['en_US']);
        $translator->addResource(
            'php',
            BASE_PATH . '/resources/locale/en_US.php',
            'en_US'
        );

        if ($lang === 'en_US') {
            return $translator;
        }

        $translator->addResource(
            'php',
            BASE_PATH . '/resources/locale/' . $lang . '.php',
            $lang
        );

        return $translator;
    }
}
