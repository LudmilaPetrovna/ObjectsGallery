<?php
// add_image.php
if ($argc < 3) {
    echo "Использование: php add_image.php <object_id> <path> [ключ=значение ...]\n";
    exit(1);
}

$db = new PDO("sqlite:" . __DIR__ . "/models.db");
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$objectId = (int)$argv[1];
$path     = $argv[2];

// дефолтные поля
$data = [
    'has_coords'   => 0,
    'cam_x'        => null, 'cam_y' => null, 'cam_z' => null,
    'obj_x'        => null, 'obj_y' => null, 'obj_z' => null,
    'capture_time' => null,
    'label'        => null,
];

for ($i = 3; $i < $argc; $i++) {
    if (strpos($argv[$i], '=') !== false) {
        [$k, $v] = explode('=', $argv[$i], 2);
        if (array_key_exists($k, $data)) {
            $data[$k] = $v;
        }
    }
}

$stmt = $db->prepare("
    INSERT INTO images (object_id, path, has_coords,
        cam_x, cam_y, cam_z, obj_x, obj_y, obj_z,
        capture_time, label)
    VALUES (:object_id, :path, :has_coords,
        :cam_x, :cam_y, :cam_z, :obj_x, :obj_y, :obj_z,
        :capture_time, :label)
");

$stmt->execute(array_merge([
    ':object_id' => $objectId,
    ':path'      => $path,
], array_combine(
    array_map(fn($k) => ":$k", array_keys($data)),
    array_values($data)
)));

echo "Добавлено изображение ID=" . $db->lastInsertId() . " к объекту $objectId\n";
