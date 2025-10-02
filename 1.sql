-- =====================
-- Таблица объектов
-- =====================
CREATE TABLE objects (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL UNIQUE,    -- внутреннее имя модели (например house_01)
    title       TEXT,                    -- человекочитаемое название
    description TEXT,                    -- описание
    source      TEXT,                    -- источник (игра/мод)
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =====================
-- Таблица изображений
-- =====================
CREATE TABLE images (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id      INTEGER NOT NULL,     -- связь с объектом
    path           TEXT NOT NULL,        -- путь к файлу
    camera_x       REAL,                 -- точка камеры (x,y,z)
    camera_y       REAL,
    camera_z       REAL,
    target_x       REAL,                 -- точка, на которую смотрит камера
    target_y       REAL,
    target_z       REAL,
    time_captured  TEXT,                 -- время съёмки (HH:MM)
    label          TEXT,                 -- метка/тип кадра (front, night, map_overlay и т.п.)
    FOREIGN KEY (object_id) REFERENCES objects(id) ON DELETE CASCADE
);

-- =====================
-- Таблица тегов
-- =====================
CREATE TABLE tags (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL UNIQUE,    -- имя тега
    type        TEXT,                    -- тип (category/material/location...)
    description TEXT,
    parent_id   INTEGER,                 -- ссылка на родительский тег
    FOREIGN KEY (parent_id) REFERENCES tags(id) ON DELETE SET NULL
);

-- =====================
-- Таблица связей "объект ↔ тег"
-- =====================
CREATE TABLE object_tags (
    object_id INTEGER NOT NULL,
    tag_id    INTEGER NOT NULL,
    PRIMARY KEY (object_id, tag_id),
    FOREIGN KEY (object_id) REFERENCES objects(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id)    REFERENCES tags(id)    ON DELETE CASCADE
);
