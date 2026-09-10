<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\GiftCard;
use App\Services\I18n;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function time;
use const PHP_EOL;

final class GiftCardController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'admin.gift_card.fields.operation',
            'id' => 'admin.gift_card.fields.id',
            'card' => 'admin.gift_card.fields.card',
            'balance' => 'admin.gift_card.fields.balance',
            'create_time' => 'admin.gift_card.fields.created_at',
            'status' => 'admin.gift_card.fields.status',
            'use_time' => 'admin.gift_card.fields.used_at',
            'use_user' => 'admin.gift_card.fields.used_by',
        ],
        'create_dialog' => [
            [
                'id' => 'card_number',
                'info' => 'admin.gift_card.fields.quantity',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'card_value',
                'info' => 'admin.gift_card.fields.card_value',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'card_length',
                'info' => 'admin.gift_card.fields.card_length',
                'type' => 'select',
                'select' => [
                    '12' => '12',
                    '18' => '18',
                    '24' => '24',
                    '30' => '30',
                    '36' => '36',
                ],
            ],
        ],
    ];

    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $details = self::$details;
        foreach ($details['field'] as $key => $value) {
            $details['field'][$key] = I18n::trans($value, $this->user->locale);
        }
        foreach ($details['create_dialog'] as &$detail) {
            $detail['info'] = I18n::trans($detail['info'], $this->user->locale);
        }
        unset($detail);
        $view->assign('details', $details);
        return $response->write($view->fetch('admin/giftcard.tpl'));
    }

    public function add(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $card_number = $request->getParam('card_number') ?? 0;
        $card_value = $request->getParam('card_value') ?? 0;
        $card_length = $request->getParam('card_length') ?? 0;
        $card_added = '';

        if ($card_number === '' || $card_number <= 0) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.gift_card.messages.quantity_invalid', $this->user->locale),
            ]);
        }

        if ($card_value === '' || $card_value <= 0) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.gift_card.messages.value_invalid', $this->user->locale),
            ]);
        }

        if ($card_length === '' || $card_length <= 0) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.gift_card.messages.length_invalid', $this->user->locale),
            ]);
        }

        for ($i = 0; $i < $card_number; $i++) {
            $card = Tools::genRandomChar((int) $card_length);
            // save to database
            $giftcard = new GiftCard();
            $giftcard->card = $card;
            $giftcard->balance = $card_value;
            $giftcard->create_time = time();
            $giftcard->status = 0;
            $giftcard->use_time = 0;
            $giftcard->use_user = 0;
            $giftcard->save();
            $card_added .= $card . PHP_EOL;
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.gift_card.messages.created', $this->user->locale) . PHP_EOL . $card_added,
        ]);
    }

    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $card_id = $args['id'];
        (new GiftCard())->find($card_id)->delete();

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.gift_card.messages.deleted', $this->user->locale),
        ]);
    }

    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $giftcards = (new GiftCard())->orderBy('id', 'desc')->get();

        foreach ($giftcards as $giftcard) {
            $giftcard->op = '<button class="btn btn-red" id="delete-gift-card-' . $giftcard->id . '" 
            onclick="deleteGiftCard(' . $giftcard->id . ')">' . I18n::trans('admin.gift_card.actions.delete', $this->user->locale) . '</button>';
            $giftcard->status = I18n::trans('admin.gift_card.status.' . $giftcard->status, $this->user->locale);
            $giftcard->create_time = Tools::toDateTime((int) $giftcard->create_time);
            $giftcard->use_time = Tools::toDateTime((int) $giftcard->use_time);
        }

        return $response->withJson([
            'giftcards' => $giftcards,
        ]);
    }
}
