<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Bought;
use App\Models\Shop;
use App\Utils\ResponseHelper;
use Slim\Http\Request;
use Slim\Http\Response;

final class ShopController extends BaseController
{
    /**
     * 后台商品页面
     *
     * @param array     $args
     */
    public function index(Request $request, Response $response, array $args)
    {
        return $response->write(
            $this->view()
                ->assign('table_config', ResponseHelper::buildTableConfig([
                    'op' => '操作',
                    'id' => 'ID',
                    'name' => '商品名称',
                    'price' => '价格',
                    'content' => '商品内容',
                    'auto_renew' => '自动续费',
                    'auto_reset_bandwidth' => '续费时是否重置流量',
                    'status' => '状态',
                    'period_sales' => '周期销量',
                ], 'shop/ajax'))
                ->display('admin/shop/index.tpl')
        );
    }

    /**
     * 后台创建新商品页面
     *
     * @param array     $args
     */
    public function create(Request $request, Response $response, array $args)
    {
        return $response->write(
            $this->view()
                ->display('admin/shop/create.tpl')
        );
    }

    /**
     * 后台添加新商品
     *
     * @param array     $args
     */
    public function add(Request $request, Response $response, array $args)
    {
        $shop = new Shop();
        $shop->name = $request->getParam('name');
        $shop->price = $request->getParam('price');
        $shop->auto_renew = $request->getParam('auto_renew');
        $shop->auto_reset_bandwidth = $request->getParam('auto_reset_bandwidth');

        $content = [];
        if ($request->getParam('bandwidth') !== 0) {
            $content['bandwidth'] = $request->getParam('bandwidth');
        }

        if ($request->getParam('expire') !== 0) {
            $content['expire'] = $request->getParam('expire');
        }

        if ($request->getParam('class') !== 0 && $request->getParam('class_expire') !== 0) {
            $content['class'] = $request->getParam('class');
            $content['class_expire'] = $request->getParam('class_expire');
        }

        if ($request->getParam('reset') !== 0) {
            $content['reset'] = $request->getParam('reset');
        }

        if ($request->getParam('reset_value') !== 0) {
            $content['reset_value'] = $request->getParam('reset_value');
        }

        if ($request->getParam('reset_exp') !== 0) {
            $content['reset_exp'] = $request->getParam('reset_exp');
        }

        if ($request->getParam('traffic_package') !== 0) {
            $content['traffic_package'] = $request->getParam('traffic_package');
        }

        $content['speedlimit'] = $request->getParam('speedlimit');

        $content['connector'] = $request->getParam('connector');

        if ($request->getParam('content_extra') !== '') {
            $content['content_extra'] = $request->getParam('content_extra');
        }

        $shop->content = $content;

        if (! $shop->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => '添加失败',
            ]);
        }
        return $response->withJson([
            'ret' => 1,
            'msg' => '添加成功',
        ]);
    }

    /**
     * 后台编辑指定商品
     *
     * @param array     $args
     */
    public function edit(Request $request, Response $response, array $args)
    {
        $id = $args['id'];
        $shop = Shop::find($id);
        return $response->write(
            $this->view()
                ->assign('shop', $shop)
                ->display('admin/shop/edit.tpl')
        );
    }

    /**
     * 后台更新指定商品内容
     *
     * @param array     $args
     */
    public function update(Request $request, Response $response, array $args)
    {
        $id = $args['id'];
        $shop = Shop::find($id);

        $shop->name = $request->getParam('name');
        $shop->price = $request->getParam('price');
        $shop->auto_renew = $request->getParam('auto_renew');

        if ($shop->auto_reset_bandwidth === 1 && $request->getParam('auto_reset_bandwidth') === 0) {
            $boughts = Bought::where('shopid', $id)->get();

            foreach ($boughts as $bought) {
                $bought->renew = 0;
                $bought->save();
            }
        }

        $shop->auto_reset_bandwidth = $request->getParam('auto_reset_bandwidth');
        $shop->status = 1;

        $content = [];
        if ($request->getParam('bandwidth') !== 0) {
            $content['bandwidth'] = $request->getParam('bandwidth');
        }

        if ($request->getParam('expire') !== 0) {
            $content['expire'] = $request->getParam('expire');
        }

        if ($request->getParam('class') !== 0 && $request->getParam('class_expire') !== 0) {
            $content['class'] = $request->getParam('class');
            $content['class_expire'] = $request->getParam('class_expire');
        }

        if ($request->getParam('reset') !== 0) {
            $content['reset'] = $request->getParam('reset');
        }

        if ($request->getParam('reset_value') !== 0) {
            $content['reset_value'] = $request->getParam('reset_value');
        }

        if ($request->getParam('reset_exp') !== 0) {
            $content['reset_exp'] = $request->getParam('reset_exp');
        }

        if ($request->getParam('traffic_package') !== 0) {
            $content['traffic_package'] = $request->getParam('traffic_package');
        }

        $content['speedlimit'] = $request->getParam('speedlimit');
        $content['connector'] = $request->getParam('connector');
        if ($request->getParam('content_extra') !== '') {
            $content['content_extra'] = $request->getParam('content_extra');
        }
        $shop->content = $content;
        if (! $shop->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => '保存失败',
            ]);
        }
        return $response->withJson([
            'ret' => 1,
            'msg' => '保存成功',
        ]);
    }

    /**
     * 后台下架指定商品
     *
     * @param array     $args
     */
    public function deleteGet(Request $request, Response $response, array $args)
    {
        $id = $request->getParam('id');
        $shop = Shop::find($id);
        $shop->status = 0;
        if (! $shop->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => '下架失败',
            ]);
        }
        $boughts = Bought::where('shopid', $id)->get();
        foreach ($boughts as $bought) {
            $bought->renew = 0;
            $bought->save();
        }
        return $response->withJson([
            'ret' => 1,
            'msg' => '下架成功',
        ]);
    }

    /**
     * 后台购买记录页面
     *
     * @param array     $args
     */
    public function bought(Request $request, Response $response, array $args)
    {
        return $response->write(
            $this->view()
                ->assign('table_config', ResponseHelper::buildTableConfig([
                    'op' => '操作',
                    'id' => 'ID',
                    'datetime' => '购买日期',
                    'content' => '内容',
                    'price' => '价格',
                    'userid' => '用户ID',
                    'user_name' => '用户名',
                    'renew' => '自动续费时间',
                    'auto_reset_bandwidth' => '续费时是否重置流量',
                ], 'bought/ajax'))
                ->display('admin/shop/bought.tpl')
        );
    }

    /**
     * 后台退订指定购买记录的自动续费
     *
     * @param array     $args
     */
    public function deleteBoughtGet(Request $request, Response $response, array $args)
    {
        $id = $request->getParam('id');
        $shop = Bought::find($id);
        $shop->renew = 0;
        if (! $shop->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => '退订失败',
            ]);
        }
        return $response->withJson([
            'ret' => 1,
            'msg' => '退订成功',
        ]);
    }

    /**
     * 后台商品页面 AJAX
     *
     * @param array     $args
     */
    public function ajaxShop(Request $request, Response $response, array $args)
    {
        $query = Shop::getTableDataFromAdmin(
            $request,
            static function (&$order_field): void {
                if (\in_array($order_field, ['op', 'period_sales'])) {
                    $order_field = 'id';
                }
            }
        );

        $data = [];
        foreach ($query['datas'] as $value) {
            /** @var Shop $value */

            $tempdata = [];
            $tempdata['op'] = '<a class="btn btn-brand" href="/admin/shop/' . $value->id . '/edit">编辑</a> <a class = "btn btn-brand-accent" ' . ($value->status === 0 ? 'disabled' : 'id="row_delete_' . $value->id . '" href="javascript:void(0);" onClick="delete_modal_show(\'' . $value->id . '\')"') . '>下架</a>';
            $tempdata['id'] = $value->id;
            $tempdata['name'] = $value->name;
            $tempdata['price'] = $value->price;
            $tempdata['content'] = $value->content();
            $tempdata['auto_renew'] = $value->autoRenew();
            $tempdata['auto_reset_bandwidth'] = $value->autoResetBandwidthString();
            $tempdata['status'] = $value->status();
            $tempdata['period_sales'] = $value->getSales();

            $data[] = $tempdata;
        }

        return $response->withJson([
            'draw' => $request->getParam('draw'),
            'recordsTotal' => Shop::count(),
            'recordsFiltered' => $query['count'],
            'data' => $data,
        ]);
    }

    /**
     * 后台购买记录 AJAX
     *
     * @param array     $args
     */
    public function ajaxBought(Request $request, Response $response, array $args)
    {
        $query = Bought::getTableDataFromAdmin(
            $request,
            static function (&$order_field): void {
                if (\in_array($order_field, ['op'])) {
                    $order_field = 'id';
                }
                if (\in_array($order_field, ['content', 'auto_reset_bandwidth'])) {
                    $order_field = 'shopid';
                }
                if (\in_array($order_field, ['user_name'])) {
                    $order_field = 'userid';
                }
            }
        );

        $data = [];
        foreach ($query['datas'] as $value) {
            /** @var Bought $value */

            $tempdata = [];
            $tempdata['op'] = '<a class="btn btn-brand-accent" ' . ($value->renew === 0 ? 'disabled' : ' id="row_delete_' . $value->id . '" href="javascript:void(0);" onClick="delete_modal_show(\'' . $value->id . '\')"') . '>中止</a>';
            $tempdata['id'] = $value->id;
            $tempdata['datetime'] = $value->datetime();
            $tempdata['content'] = $value->content();
            $tempdata['price'] = $value->price;
            $tempdata['userid'] = $value->userid;
            $tempdata['user_name'] = $value->userName();
            $tempdata['renew'] = $value->renew();
            $tempdata['auto_reset_bandwidth'] = $value->autoResetBandwidthString();

            $data[] = $tempdata;
        }

        return $response->withJson([
            'draw' => $request->getParam('draw'),
            'recordsTotal' => Bought::count(),
            'recordsFiltered' => $query['count'],
            'data' => $data,
        ]);
    }
}
