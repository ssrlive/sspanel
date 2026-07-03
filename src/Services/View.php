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
        $smarty->assign('config', self::getConfig());
        $smarty->assign('public_setting', Config::getPublicConfig());
        $smarty->assign('user', $user);

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
        return [
            'appName' => Env::getString('appName'),
            'baseUrl' => Env::getString('baseUrl'),
            'jump_delay' => Env::getString('jump_delay'),
            'enable_kill' => Env::getBool('enable_kill'),
            'enable_change_email' => Env::getBool('enable_change_email'),
            'enable_r2_client_download' => Env::getBool('enable_r2_client_download'),
            'jsdelivr_url' => Env::getString('jsdelivr_url'),
            // site default language
            'locale' => Env::getString('locale'),
        ];
    }
}
