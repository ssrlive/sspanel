<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\Config;
use App\Models\Link;
use App\Models\SubscribeLog;
use App\Services\RateLimit;
use App\Services\Subscribe;
use App\Utils\Env;
use App\Utils\ResponseHelper;
use GuzzleHttp\Exception\GuzzleException;
use Psr\Http\Client\ClientExceptionInterface;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function in_array;
use function strtotime;

final class SubController extends BaseController
{
    /**
     * @throws ClientExceptionInterface
     * @throws GuzzleException
     * @throws \RedisException
     * @throws TelegramSDKException
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $err_msg = '订阅链接无效';
        $subtype = $args['subtype'];
        $subtype_list = ['json', 'clash', 'sip008', 'singbox', 'v2rayjson', 'sip002', 'ss', 'v2ray', 'trojan'];

        if (
            ($subtype === 'json' && Config::obtain('enable_json_sub') === false) ||
            ($subtype === 'clash' && Config::obtain('enable_clash_sub') === false) ||
            ($subtype === 'singbox' && Config::obtain('enable_singbox_sub') === false) ||
            ($subtype === 'v2rayjson' && Config::obtain('enable_v2rayjson_sub') === false) ||
            ! Env::get('Subscribe') ||
            ! in_array($subtype, $subtype_list) ||
            'https://' . $request->getHeaderLine('Host') !== Env::get('subUrl')
        ) {
            return ResponseHelper::error($response, $err_msg);
        }

        $token = $this->antiXss->xss_clean($args['token']);

        if (
            Env::get('enable_rate_limit') &&
            (! (new RateLimit())->checkRateLimit('sub_ip', $request->getServerParam('REMOTE_ADDR')) ||
                ! (new RateLimit())->checkRateLimit('sub_token', $token))
        ) {
            return ResponseHelper::error($response, $err_msg);
        }

        $link = (new Link())->where('token', $token)->first();

        if ($link === null || ! $link->isValid()) {
            return ResponseHelper::error($response, $err_msg);
        }

        $user = $link->user();
        $sub_info = Subscribe::getContent($user, $subtype);

        $content_type = match ($subtype) {
            'clash' => 'application/yaml',
            'json', 'sip008', 'singbox', 'v2rayjson' => 'application/json',
            default => 'text/plain',
        };

        $sub_details = ' upload=' . $user->u
            . '; download=' . $user->d
            . '; total=' . $user->transfer_enable
            . '; expire=' . strtotime($user->class_expire);
        // Clash specific
        $sub_content_disposition = 'attachment; filename=' . Env::get('appName');
        $sub_profile_update_interval = 6;
        $sub_profile_web_page_url = Env::get('baseUrl');

        if (Config::obtain('subscribe_log')) {
            (new SubscribeLog())->add(
                $user,
                $subtype,
                $this->antiXss->xss_clean($request->getHeaderLine('User-Agent')),
                $request->getServerParam('REMOTE_ADDR') ?? ''
            );
        }

        if ($subtype === 'clash') {
            return $response->withHeader('Subscription-Userinfo', $sub_details)
                ->withHeader('Content-Disposition', $sub_content_disposition)
                ->withHeader('Profile-Update-Interval', $sub_profile_update_interval)
                ->withHeader('Profile-Web-Page-Url', $sub_profile_web_page_url)
                ->withHeader('Content-Type', $content_type)
                ->write($sub_info);
        }

        return $response->withHeader('Subscription-Userinfo', $sub_details)
            ->withHeader('Content-Type', $content_type)
            ->write($sub_info);
    }
}
