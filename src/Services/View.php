<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Config;
use App\Models\User;
use App\Utils\Env;
use Illuminate\Database\DatabaseManager;
use Smarty\Smarty;
use Twig\Environment;
use Twig\Loader\FilesystemLoader;
use const BASE_PATH;

final class View
{
    public static DatabaseManager $connection;
    public static float $beginTime;

    public static function getSmarty(): Smarty
    {
        $smarty = new Smarty(); //实例化smarty
        $user = Auth::getUser();

        $smarty->setTemplateDir(BASE_PATH . '/resources/views/' . self::getTheme($user) . '/'); //设置模板文件存放目录
        $smarty->setCompileDir(BASE_PATH . '/storage/framework/smarty/compile/'); //设置生成文件存放目录
        $smarty->setCacheDir(BASE_PATH . '/storage/framework/smarty/cache/'); //设置缓存文件存放目录
        // add config
        $config = self::getConfig();
        $smarty->assign('config', $config);
        $smarty->assign('public_setting', Config::getPublicConfig());
        $smarty->assign('user', $user);
        $smarty->assign('locale_options', I18n::getLocaleOptions());
        $smarty->registerPlugin('function', 'trans', static function (array $params) use ($config): string {
            $key = (string) $params['key'];
            unset($params['key']);

            foreach ($params as $name => $value) {
                if ($name[0] !== '%') {
                    $params['%' . $name . '%'] = $value;
                    unset($params[$name]);
                }
            }

            return I18n::trans($key, $config['locale'], $params);
        });

        return $smarty;
    }

    public static function getTwig(): Environment
    {
        $user = Auth::getUser();
        $loader = new FilesystemLoader(BASE_PATH . '/resources/views/' . self::getTheme($user) . '/');

        $twig = new Environment($loader, [
            'cache' => BASE_PATH . '/storage/framework/twig/cache/',
        ]);

        $twig->addGlobal('config', self::getConfig());
        $twig->addGlobal('public_setting', Config::getPublicConfig());
        $twig->addGlobal('user', $user);
        $twig->addGlobal('locale_options', I18n::getLocaleOptions());

        return $twig;
    }

    public static function getTheme(User $user): string
    {
        if ($user->isLogin) {
            $theme = $user->theme;
        } else {
            $theme = Env::getString('theme');
        }

        return $theme;
    }

    public static function getConfig(): array
    {
        $user = Auth::getUser();

        return [
            'appName' => Env::getString('appName'),
            'baseUrl' => Env::getString('baseUrl'),
            'jump_delay' => Env::getString('jump_delay'),
            'enable_kill' => Env::getBool('enable_kill'),
            'enable_change_email' => Env::getBool('enable_change_email'),
            'enable_r2_client_download' => Env::getBool('enable_r2_client_download'),
            'jsdelivr_url' => Env::getString('jsdelivr_url'),
            // site default language
            'locale' => $user->isLogin && in_array($user->locale, I18n::getLocaleList(), true)
                ? $user->locale
                : Env::getString('locale'),
        ];
    }
}
