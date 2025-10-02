-- =====================
-- Таблица объектов
-- =====================
CREATE TABLE objects (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    name          TEXT NOT NULL UNIQUE,    -- внутреннее имя (например vgwbitodirt)
    title         TEXT,                    -- человекочитаемое название
    description   TEXT,                    -- описание
    source        TEXT,                    -- откуда объект (игра/мод)

    -- Численные параметры
    size_radius   REAL,                    -- радиус объекта
    bbox_length   REAL,                    -- bounding box length
    bbox_width    REAL,                    -- bounding box width
    bbox_height   REAL,                    -- bounding box height
    draw_distance REAL,                    -- дистанция видимости (LOD)
    usage_count   INTEGER,                 -- сколько раз встречается в карте

    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =====================
-- Таблица изображений
-- =====================
CREATE TABLE images (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id      INTEGER NOT NULL,     -- связь с объектом
    path           TEXT NOT NULL,        -- путь к файлу

    -- Камера и цель
    has_coords     INTEGER DEFAULT 0,    -- 0 = координаты не заданы, 1 = заданы
    camera_x       REAL,
    camera_y       REAL,
    camera_z       REAL,
    target_x       REAL,
    target_y       REAL,
    target_z       REAL,

    time_captured  TEXT,                 -- время съёмки (HH:MM)
    label          TEXT,                 -- метка кадра (front, night, etc.)

    FOREIGN KEY (object_id) REFERENCES objects(id) ON DELETE CASCADE
);

-- =====================
-- Таблица тегов
-- =====================
CREATE TABLE tags (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL UNIQUE,    -- имя тега (animated, breakable, etc.)
    type        TEXT,                    -- тип (property/location/material)
    description TEXT,
    parent_id   INTEGER,                 -- иерархия тегов
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

-- =====================
-- Таблица файлов, связанных с объектами
-- =====================
CREATE TABLE files (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id  INTEGER NOT NULL,
    file_type  TEXT NOT NULL,            -- DFF / TXD / IDE / COL / IFP
    file_name  TEXT NOT NULL,
    FOREIGN KEY (object_id) REFERENCES objects(id) ON DELETE CASCADE
);

-- =====================
-- Таблица комментариев
-- =====================
CREATE TABLE comments (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id  INTEGER NOT NULL,         -- к какому объекту комментарий
    nickname   TEXT NOT NULL,            -- никнейм пользователя
    text       TEXT NOT NULL,            -- текст комментария
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (object_id) REFERENCES objects(id) ON DELETE CASCADE
);

-- =====================
-- Таблица "объекты рядом"
-- =====================
CREATE TABLE object_neighbors (
    object_id     INTEGER NOT NULL,
    neighbor_id   INTEGER NOT NULL,
    PRIMARY KEY (object_id, neighbor_id),
    FOREIGN KEY (object_id)   REFERENCES objects(id) ON DELETE CASCADE,
    FOREIGN KEY (neighbor_id) REFERENCES objects(id) ON DELETE CASCADE
);
