<?php
// add_object.php
if ($argc < 3) {
    echo "Использование: php add_object.php <name> <title> [ключ=значение ...] [tags=tag1,tag2,...]\n";
    exit(1);
}

$db = new PDO("sqlite:" . __DIR__ . "/models.db");
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// базовые поля
$name  = $argv[1];
$title = $argv[2];

// дефолтные значения
$data = [
    'description'   => null,
    'source'        => null,
    'draw_distance' => null,
    'usage_count'   => 0,
    'has_collision' => 0,
    'has_animation' => 0,
    'size_radius'   => null,
    'size_length'   => null,
    'size_width'    => null,
    'size_height'   => null,
];

$tags = [];

// разбираем аргументы формата key=value
for ($i = 3; $i < $argc; $i++) {
    if (strpos($argv[$i], '=') !== false) {
        [$k, $v] = explode('=', $argv[$i], 2);
        if ($k === 'tags') {
            $tags = array_map('trim', explode(',', $v));
        } elseif (array_key_exists($k, $data)) {
            $data[$k] = $v;
        }
    }
}

// вставляем объект
$stmt = $db->prepare("
    INSERT INTO objects (name, title, description, source, draw_distance, usage_count,
        has_collision, has_animation, size_radius, size_length, size_width, size_height)
    VALUES (:name, :title, :description, :source, :draw_distance, :usage_count,
        :has_collision, :has_animation, :size_radius, :size_length, :size_width, :size_height)
");
$stmt->execute(array_merge([
    ':name'  => $name,
    ':title' => $title,
], array_combine(
    array_map(fn($k) => ":$k", array_keys($data)),
    array_values($data)
)));

$objectId = $db->lastInsertId();

// теги
foreach ($tags as $tagName) {
    if ($tagName === '') continue;
    $tagStmt = $db->prepare("INSERT OR IGNORE INTO tags (name) VALUES (:name)");
    $tagStmt->execute([':name' => $tagName]);

    $tagId = $db->query("SELECT id FROM tags WHERE name = " . $db->quote($tagName))->fetchColumn();

    $linkStmt = $db->prepare("INSERT OR IGNORE INTO object_tags (object_id, tag_id) VALUES (:oid, :tid)");
    $linkStmt->execute([':oid' => $objectId, ':tid' => $tagId]);
}

echo "Добавлен объект ID=$objectId ($name)\n";
