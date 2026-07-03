<?php

declare(strict_types=1);

namespace App\Services;

use App\Utils\Env;
use Aws\Credentials\Credentials;
use Aws\S3\S3Client;
use Exception;

final class Cloudflare
{
    public static function initR2(): S3Client
    {
        $credentials = new Credentials(Env::get('r2_access_key_id'), Env::get('r2_access_key_secret'));

        $options = [
            'region' => 'auto',
            'endpoint' => 'https://' . Env::get('r2_account_id') . '.r2.cloudflarestorage.com',
            'version' => 'latest',
            'credentials' => $credentials,
        ];

        return new S3Client($options);
    }

    public static function uploadR2(string $name, string $file): void
    {
        $r2 = self::initR2();

        try {
            $r2->upload(
                Env::get('r2_bucket_name'),
                $name,
                $file,
            );
        } catch (Exception $e) {
            echo $e->getMessage() . PHP_EOL;
        }
    }

    public static function genR2PresignedUrl(string $fileName): string
    {
        $r2 = self::initR2();

        $cmd = $r2->getCommand('GetObject', [
            'Bucket' => Env::get('r2_bucket_name'),
            'Key' => $fileName,
        ]);

        return (string) $r2->createPresignedRequest(
            $cmd,
            '+' . Env::get('r2_client_download_timeout') . ' minutes'
        )->getUri();
    }
}
