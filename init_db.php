<?php
// init_db.php
$dbFile = __DIR__ . '/models.db';

if (file_exists($dbFile)) {
    unlink($dbFile);
    echo "Удалён старый файл БД.\n";
}

$db = new PDO("sqlite:$dbFile");
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// включаем поддержку foreign keys
$db->exec("PRAGMA foreign_keys = ON;");

// загружаем схему из внешнего файла schema.sql
$schema = file_get_contents(__DIR__ . '/schema.sql');
$db->exec($schema);

echo "База данных создана: $dbFile\n";
