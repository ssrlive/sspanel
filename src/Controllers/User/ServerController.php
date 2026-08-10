<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use App\Services\Subscribe;
use App\Services\Subscribe\AnyTLS;
use App\Services\Subscribe\OverTLS;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class ServerController extends BaseController
{
    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $nodes = Subscribe::getUserNodes($this->user, true);
        $node_list = [];

        /** @var \App\Models\Node $node */
        foreach ($nodes as $node) {
            $node_type = $node->sort();
            $node_url = $this->user->class >= $node->node_class
                && ($node_type === 'OverTLS' || $node_type === 'AnyTLS')
                && $node->getNodeOnlineStatus() === 1
                ? ($node_type === 'OverTLS'
                    ? OverTLS::assembleNodeUrl($node, $this->user->uuid)
                    : AnyTLS::assembleNodeUrl($node, $this->user->uuid)) : '';

            $node_list[] = [
                'id' => $node->id,
                'name' => $node->name,
                'class' => (int) $node->node_class,
                'color' => $node->color,
                'connection_type' => $node->connection_type,
                'sort' => $node_type,
                'online_user' => $node->online_user,
                'online' => $node->getNodeOnlineStatus(),
                'traffic_rate' => $node->traffic_rate,
                'is_dynamic_rate' => $node->is_dynamic_rate,
                'node_bandwidth' => Tools::autoBytes($node->node_bandwidth),
                'node_bandwidth_limit' => $node->node_bandwidth_limit === 0 ? '无限制' :
                    Tools::autoBytes($node->node_bandwidth_limit),
                'node_url' => $node_url,
            ];
        }

        $view = $this->view();
        $view->assign('servers', $node_list);
        return $response->write($view->fetch('user/server.tpl'));
    }
}
