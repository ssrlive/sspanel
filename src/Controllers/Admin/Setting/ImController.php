<?php

declare(strict_types=1);

namespace App\Controllers\Admin\Setting;

use App\Controllers\BaseController;
use App\Models\Config;
use App\Services\I18n;
use App\Services\IM\Discord;
use App\Services\IM\Slack;
use App\Services\IM\Telegram;
use App\Utils\Env;
use App\Utils\Tools;
use GuzzleHttp\Exception\GuzzleException;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Smarty\Exception;
use Telegram\Bot\Api;
use Telegram\Bot\Exceptions\TelegramSDKException;

final class ImController extends BaseController
{
    private static string $success_msg = 'admin.im.messages.test_success';
    private static string $err_msg = 'admin.im.messages.test_failed';
    private array $update_field;
    private array $settings;

    public function __construct()
    {
        parent::__construct();
        $this->update_field = Config::getItemListByClass('im');
        $this->settings = Config::getClass('im');
    }

    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $view->assign('update_field', $this->update_field)
            ->assign('settings', $this->settings);
        return $response->write($view->fetch('admin/setting/im.tpl'));
    }

    public function save(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        foreach ($this->update_field as $item) {
            if (! Config::set($item, $request->getParam($item))) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => I18n::trans('admin.im.messages.save_failed', $this->user->locale, ['field' => $item]),
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.im.messages.saved', $this->user->locale),
        ]);
    }

    public function resetWebhookToken(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $type = $args['type'];

        if ($type === 'telegram') {
            Config::set('telegram_webhook_token', Tools::genRandomChar(32));

            return $response->withJson([
                'ret' => 1,
                'msg' => I18n::trans('admin.im.messages.webhook_reset', $this->user->locale),
                'data' => [
                    'telegram_webhook_token' => Config::obtain('telegram_webhook_token'),
                ],
            ]);
        }

        return $response->withJson([
            'ret' => 0,
            'msg' => I18n::trans('admin.im.messages.unknown_webhook', $this->user->locale),
        ]);
    }

    public function setWebhook(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $type = $args['type'];

        if ($type === 'telegram') {
            $webhook_url = Env::get('baseUrl') . '/callback/telegram?token=' . Config::obtain('telegram_webhook_token');

            try {
                $telegram = new Api($request->getParam('bot_token'));
                $telegram->removeWebhook();
                $telegram->setWebhook(['url' => $webhook_url]);

                return $response->withJson([
                    'ret' => 1,
                    'msg' => I18n::trans('admin.im.messages.webhook_set', $this->user->locale, ['username' => $telegram->getMe()->getUsername()]),
                ]);
            } catch (TelegramSDKException) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => I18n::trans('admin.im.messages.webhook_set_failed', $this->user->locale),
                ]);
            }
        }

        return $response->withJson([
            'ret' => 0,
            'msg' => I18n::trans('admin.im.messages.unknown_webhook', $this->user->locale),
        ]);
    }

    public function testTelegram(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        try {
            (new Telegram())->send(
                (int) $request->getParam('telegram_chat_id'),
                I18n::trans('bot.test_message', Env::get('locale')),
            );
        } catch (TelegramSDKException | \Exception $e) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans($this::$err_msg, $this->user->locale) . ' ' . $e->getMessage(),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans($this::$success_msg, $this->user->locale),
        ]);
    }

    public function testDiscord(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        try {
            (new Discord())->send(
                (int) $request->getParam('discord_channel_id'),
                I18n::trans('bot.test_message', Env::get('locale')),
            );
        } catch (GuzzleException | \Exception $e) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans($this::$err_msg, $this->user->locale) . ' ' . $e->getMessage(),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans($this::$success_msg, $this->user->locale),
        ]);
    }

    public function testSlack(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        try {
            (new Slack())->send(
                (int) $request->getParam('slack_channel_id'),
                I18n::trans('bot.test_message', Env::get('locale')),
            );
        } catch (GuzzleException | \Exception $e) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans($this::$err_msg, $this->user->locale) . ' ' . $e->getMessage(),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans($this::$success_msg, $this->user->locale),
        ]);
    }
}
