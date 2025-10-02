PRAGMA foreign_keys = ON;

-- ==============
-- Таблица objects
-- ==============
CREATE TABLE objects (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    name             TEXT NOT NULL UNIQUE,    -- внутреннее имя (например vgwbitodirt)
    title            TEXT,                    -- человекочитаемое название
    description      TEXT,
    source           TEXT,                    -- источник (игра/мод)
    wiki           TEXT,                    -- ссылка на вики

    -- численные параметры
    draw_distance    REAL,                    -- дистанция видимости (LOD) в метрах
    usage_count      INTEGER DEFAULT 0,       -- сколько раз встречается в карте

    col_id      INTEGER DEFAULT 0,
    ide_id      INTEGER DEFAULT 0,

--    has_collision    INTEGER DEFAULT 0,       -- 0/1
--    has_animation    INTEGER DEFAULT 0,       -- 0/1
--    is_lod    INTEGER DEFAULT 0,       -- 0/1

    size_radius      REAL,
    size_length      REAL,
    size_width       REAL,
    size_height      REAL,

    created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============
-- Таблица tags
-- ============
CREATE TABLE tags (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL UNIQUE,    -- имя тега (animated, breakable, beach-santa-maria, ...)
    type        TEXT,                    -- тип тега (property/location/material/...)
    description TEXT,
    parent_id   INTEGER,                 -- ссылка на родителя
    FOREIGN KEY (parent_id) REFERENCES tags(id) ON DELETE SET NULL
);

-- =======================
-- Связующая таблица object_tags
-- =======================
CREATE TABLE object_tags (
    object_id INTEGER NOT NULL,
    tag_id    INTEGER NOT NULL,
    PRIMARY KEY (object_id, tag_id),
    FOREIGN KEY (object_id) REFERENCES objects(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id)    REFERENCES tags(id)    ON DELETE CASCADE
);

-- ==============
-- Таблица images
-- ==============
CREATE TABLE images (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id     INTEGER,                 -- связь с объектом
    path          TEXT NOT NULL,           -- путь к файлу

    has_coords    INTEGER DEFAULT 0,       -- 0 = координаты не заданы, 1 = заданы
    cam_x         REAL, cam_y REAL, cam_z REAL,   -- точка камеры
    obj_x         REAL, obj_y REAL, obj_z REAL,   -- точка/позиция объекта (цель)

    capture_time  TEXT,                    -- время съёмки (HH:MM)
    label         TEXT,                    -- метка кадра (front, side, night, map_overlay и т.п.)

    FOREIGN KEY (object_id) REFERENCES objects(id) ON DELETE CASCADE
);

-- ================
-- Таблица comments
-- ================
CREATE TABLE comments (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id    INTEGER,
    author       TEXT NOT NULL,
    text         TEXT NOT NULL,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (object_id) REFERENCES objects(id) ON DELETE CASCADE
);

-- ==========
-- Таблица files
-- ==========
CREATE TABLE files (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id   INTEGER,
    file_type   TEXT NOT NULL,            -- DFF / TXD / IDE / COL / IFP / ...
    file_name   TEXT NOT NULL,
    FOREIGN KEY (object_id) REFERENCES objects(id) ON DELETE CASCADE
);

-- ======================
-- Таблица object_neighbors
-- ======================
CREATE TABLE object_neighbors (
    object_id   INTEGER NOT NULL,
    neighbor_id INTEGER NOT NULL,
    PRIMARY KEY (object_id, neighbor_id),
    FOREIGN KEY (object_id)   REFERENCES objects(id) ON DELETE CASCADE,
    FOREIGN KEY (neighbor_id) REFERENCES objects(id) ON DELETE CASCADE
);

-- ===========
-- Индексы
-- ===========
-- ускоряют LIKE/автодополнение (COLLATE NOCASE — нечувствительность к регистру)
CREATE INDEX idx_tags_name ON tags(name COLLATE NOCASE);
CREATE INDEX idx_tags_type ON tags(type);

CREATE INDEX idx_objects_name ON objects(name COLLATE NOCASE);
CREATE INDEX idx_objects_title ON objects(title COLLATE NOCASE);

CREATE INDEX idx_object_tags_object ON object_tags(object_id);
CREATE INDEX idx_object_tags_tag ON object_tags(tag_id);

CREATE INDEX idx_images_object ON images(object_id);
CREATE INDEX idx_images_path ON images(path);

CREATE INDEX idx_files_object ON files(object_id);
CREATE INDEX idx_neighbors_object ON object_neighbors(object_id);

CREATE INDEX idx_comments_object ON comments(object_id);
