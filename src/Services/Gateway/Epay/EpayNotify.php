<?php

declare(strict_types=1);

namespace App\Services\Gateway\Epay;

final class EpayNotify
{
    private array $epay_config;

    public function __construct(array $epay_config)
    {
        $this->epay_config = $epay_config;
    }

    public function verifyNotify(array $params): bool
    {
        if (count($params) === 0 || ! isset($params['sign'])) {
            return false;
        }

        if ($this->getSignVeryfy($params, (string) $params['sign'])) {
            return true;
        }

        return false;
    }

    public function getSignVeryfy(array $para_temp, string $sign): bool
    {
        //除去待签名参数数组中的空值和签名参数
        $para_filter = EpayTool::paraFilter($para_temp);
        //对待签名参数数组排序
        $para_sort = EpayTool::argSort($para_filter);
        //把数组所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串
        $prestr = EpayTool::createLinkstring($para_sort);

        return EpayTool::verify($prestr, $sign, $this->epay_config['key']);
    }
}
