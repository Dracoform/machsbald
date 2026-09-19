-- MySQL 8.4; run once in an already-created database.
-- Category keys are stable application values; display labels are documented below.
CREATE TABLE tasks (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    text VARCHAR(1000) NOT NULL,
    category ENUM(
        'eigentlich_gestern',
        'asap',
        'fixes_datum',
        'diese_woche',
        'irgendwann',
        'wenn_mir_langweilig_ist'
    ) NOT NULL DEFAULT 'eigentlich_gestern',
    due_date DATE NULL,
    details TEXT NULL,
    is_done TINYINT(1) NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    INDEX idx_tasks_category_done (category, is_done, due_date, id),
    CONSTRAINT chk_tasks_text CHECK (CHAR_LENGTH(TRIM(text)) > 0),
    CONSTRAINT chk_tasks_done CHECK (is_done IN (0, 1)),
    CONSTRAINT chk_tasks_due_date CHECK (
        (category = 'fixes_datum' AND due_date IS NOT NULL)
        OR (category <> 'fixes_datum' AND due_date IS NULL)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE subtasks (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    task_id BIGINT UNSIGNED NOT NULL,
    text VARCHAR(1000) NOT NULL,
    sort_order INT UNSIGNED NOT NULL,
    is_done TINYINT(1) NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    INDEX idx_subtasks_display (task_id, is_done, sort_order, id),
    CONSTRAINT fk_subtasks_task FOREIGN KEY (task_id)
        REFERENCES tasks (id) ON DELETE CASCADE,
    CONSTRAINT chk_subtasks_text CHECK (CHAR_LENGTH(TRIM(text)) > 0),
    CONSTRAINT chk_subtasks_done CHECK (is_done IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Category key -> scope label:
-- eigentlich_gestern -> Eigentlich gestern (default)
-- asap -> ASAP
-- fixes_datum -> Fixes Datum
-- diese_woche -> Diese Woche
-- irgendwann -> Irgendwann
-- wenn_mir_langweilig_ist -> Wenn mir langweilig ist
-- Display checklist items with ORDER BY is_done ASC, sort_order ASC, id ASC.
