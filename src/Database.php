<?php

declare(strict_types=1);

namespace Machsbald;

use PDO;
use RuntimeException;

final class Database
{
    public static function connect(): PDO
    {
        $configuredPath = getenv('MACHSBALD_DB_CONFIG');
        $path = $configuredPath !== false && $configuredPath !== ''
            ? $configuredPath
            : dirname(__DIR__) . '/config/database.local.php';

        if (!is_file($path) || !is_readable($path)) {
            throw new RuntimeException('Database configuration is missing or unreadable.');
        }

        $config = require $path;
        if (!is_array($config)) {
            throw new RuntimeException('Database configuration must return an array.');
        }

        foreach (['host', 'port', 'database', 'username', 'password'] as $key) {
            if (!array_key_exists($key, $config)) {
                throw new RuntimeException("Database configuration is missing: {$key}.");
            }
        }

        if (!is_string($config['host']) || $config['host'] === ''
            || !is_int($config['port']) || $config['port'] < 1 || $config['port'] > 65535
            || !is_string($config['database']) || $config['database'] === ''
            || !is_string($config['username']) || $config['username'] === ''
            || !is_string($config['password'])) {
            throw new RuntimeException('Database configuration has invalid values.');
        }

        $dsn = sprintf(
            'mysql:host=%s;port=%d;dbname=%s;charset=utf8mb4',
            $config['host'],
            $config['port'],
            $config['database']
        );

        return new PDO($dsn, $config['username'], $config['password'], [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]);
    }
}
