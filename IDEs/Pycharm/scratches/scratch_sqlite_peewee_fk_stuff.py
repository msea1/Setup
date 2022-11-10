import sqlite3

from yoyo import step
from yoyo.backends import DatabaseBackend

# for peewee FK, 'field' refers to column in FK'd table to match while 'column_name' refers to what to call the column on THIS table
# run_id: str = ForeignKeyField(DioptraProcessModel, field='run_id', backref='plugin_output', column_name='run_id')
# step_number: int = ForeignKeyField(DioptraProcessModel, field='step_number', backref='plugin_output', column_name='step_number')
# diagnostics: dict = JSONField(null=False)


PLUGIN_TABLE_NAMES_TO_ALTER = [  # current list at time of this migration
    "step_bad_column_zapper",
    "step_dehaze",
    "step_demosaic",
    "step_feature_detection",
    "step_flat_field_correction",
    "step_georeference",
    "step_image_metrics",
    "step_lunar_calibration",
    "step_range_adjust",
    "step_stellar_calibration"
]


# Sqlite does not allow adding foreign keys to an existing table. Awesome. They want you instead to do the following:
# 1. Create a new table, 2. Copy data to it, 3. Drop the old table, 4. Rename new table to old name
# However, we only use sqlite for testing purposes. Which means they're created fresh and have no data in them.
# So we can simplify this to just drop and create.
def sqlite_add_fk(sqlite_conn: sqlite3.Connection, fk_info: str) -> None:
    cursor = sqlite_conn.cursor()
    for table in PLUGIN_TABLE_NAMES_TO_ALTER:
        # before we drop it, preserve the sql to create it
        creation_str = cursor.execute(f"SELECT sql FROM sqlite_master WHERE type='table' AND name='{table}'").fetchone()[0]
        creation_str = creation_str[:-1]  # drop the closing paren
        creation_str += ",\n            "  # add white space in line with exsiting format
        creation_str += fk_info  # add the new FK
        creation_str += ")"  # re-add closing paren

        cursor.execute(f"DROP TABLE {table}")
        cursor.execute(creation_str)  # arise, phoenix!


def add_foreign_key(conn: DatabaseBackend):
    fk_info = "FOREIGN KEY (run_id, step_number) REFERENCES dioptra_process (run_id, step_number)"
    if isinstance(conn, sqlite3.Connection):
        return sqlite_add_fk(conn, fk_info)
    cursor = conn.cursor()
    alter_stmts = [f"ALTER TABLE {table} ADD CONSTRAINT {table}_fk_process {fk_info};" for table in PLUGIN_TABLE_NAMES_TO_ALTER]
    for i in alter_stmts:
        cursor.execute(i)


def sqlite_drop_fk(sqlite_conn: sqlite3.Connection) -> None:
    # do the reverse of add above
    cursor = sqlite_conn.cursor()
    for table in PLUGIN_TABLE_NAMES_TO_ALTER:
        # before we drop it, preserve the sql to create it
        creation_str = cursor.execute(f"SELECT sql FROM sqlite_master WHERE type='table' AND name='{table}'").fetchone()[0]
        creation_str_list = creation_str.splitlines()[:-1]  # drop the last line
        creation_str = "\n".join(creation_str_list)  # re-combine
        creation_str = creation_str[:-1]  # drop the closing comma
        creation_str += ")"  # add closing paren

        cursor.execute(f"DROP TABLE {table}")
        cursor.execute(creation_str)  # arise, phoenix!


def drop_foreign_key(conn: DatabaseBackend):
    if isinstance(conn, sqlite3.Connection):
        return sqlite_drop_fk(conn)
    cursor = conn.cursor()
    alter_stmts = [f"ALTER TABLE {table} DROP CONSTRAINT {table}_fk_process;" for table in PLUGIN_TABLE_NAMES_TO_ALTER]
    for i in alter_stmts:
        cursor.execute(i)


def sqlite_allow_null(sqlite_conn: sqlite3.Connection) -> None:
    cursor = sqlite_conn.cursor()
    cursor.execute("DROP TABLE payload_image")
    cursor.execute(payload_image_table_syntax(null_allowed=True))  # arise, phoenix!


def sqlite_forbid_null(sqlite_conn: sqlite3.Connection) -> None:
    cursor = sqlite_conn.cursor()
    cursor.execute("DROP TABLE payload_image")
    cursor.execute(payload_image_table_syntax(null_allowed=False))


def payload_image_table_syntax(null_allowed: bool) -> str:
    # grabbed from 003_create_data_tables migration
    return f"""
     CREATE TABLE IF NOT EXISTS "payload_image" (
        "image_id" INTEGER NOT NULL,
        "md5_hex" TEXT NOT NULL,
        "spacecraft_id" INTEGER NOT NULL,
        "file_path" TEXT NOT NULL,
        "mmr_filename" TEXT {'' if null_allowed else 'NOT NULL'},
        "contact_pass_id" TEXT {'' if null_allowed else 'NOT NULL'},
        "command_id" INTEGER,
        "camera_model_config_id" INTEGER NOT NULL,
        PRIMARY KEY ("image_id"),
        FOREIGN KEY ("image_id") REFERENCES "images" ("image_id"),
        FOREIGN KEY ("camera_model_config_id") REFERENCES "dioptra_camera_model" ("config_id"))
     """


steps = [step(apply=add_foreign_key, rollback=drop_foreign_key)]


def change_type_to_array(conn: DatabaseBackend):
    cursor = conn.cursor()
    cursor.execute("ALTER TABLE workflow_run ALTER COLUMN step_names TYPE TEXT[] USING ARRAY[step_names];")
    cursor.execute("ALTER TABLE capture_data ALTER COLUMN related_images TYPE INT[] USING string_to_array("
                   "LTRIM(RTRIM(related_images, ']'), '['), ',')::int[]")


def revert_type_to_text(conn: DatabaseBackend):
    cursor = conn.cursor()
    cursor.execute("ALTER TABLE workflow_run ALTER COLUMN step_names TYPE TEXT USING array_to_string(step_names, ',')")
    cursor.execute("ALTER TABLE capture_data ALTER COLUMN related_images TYPE TEXT USING array_to_string(related_images, ',')")


steps = [
    step(apply=change_type_to_array, rollback=revert_type_to_text),
]

