# Local development

Phase 1 provides the database schema, configuration loader and an authenticated
webroot foundation. It does not implement the todo interface yet.

## Requirements

- PHP 8.5 with `pdo_mysql`
- MySQL 8.4
- Apache 2.4 with `.htaccess` support to test HTTP Basic Authentication

No Composer or Node dependencies are required.

## Database

Create a dedicated empty MySQL database and a database user with rights to that
database. Then import the schema once:

```sh
mysql -u YOUR_DB_USER -p YOUR_DB_NAME < database/schema.sql
```

The schema contains `tasks` and `subtasks`. Category values are stable keys;
their exact German labels are listed in `database/schema.sql`. `eigentlich_gestern`
is the database default. A task in `fixes_datum` must have `due_date`; other
categories must not have one. Subtasks have no category or date columns and
therefore inherit urgency from their task. Deleting a task deletes its subtasks.
For display, sort subtasks by `is_done ASC, sort_order ASC, id ASC`; this places
completed items below open ones without altering their stored order.

## Configuration

Copy `config/database.example.php` to `config/database.local.php` and replace
the sample values. The local file is ignored by Git and is outside `public/`.
For a file elsewhere, set `MACHSBALD_DB_CONFIG` to its absolute path in the PHP
process environment. The loader uses this path when set, otherwise
`config/database.local.php`. The file must return the array shown in the example.
Do not commit real database values.

`Machsbald\Database::connect()` in `src/Database.php` is the PDO entry point.
It uses UTF-8, exceptions, associative fetches and native prepared statements.
The placeholder page does not connect to the database yet.

## Webserver

Set the document root to `public/`. For Apache, copy
`server/apache-public.htaccess.example` to `public/.htaccess`, replace
`AuthUserFile` with the absolute path of a password file outside the document
root, and create that file with `htpasswd`. Keep the real `.htaccess` and
password file unversioned. Configure Apache to allow the `AuthConfig`,
`Options` and `Indexes` overrides required by the file. The root `.htaccess`
denies access if the project root is accidentally served.

For quick PHP-only smoke testing, `php -S 127.0.0.1:8000 -t public` serves the
placeholder page. PHP's built-in server does not process `.htaccess` or provide
HTTP Authentication. Use Apache for authentication checks and never expose the
built-in server to a network.

## Basic checks

```sh
php -l public/index.php
php -l src/Database.php
php -l config/database.example.php
mysql -u YOUR_DB_USER -p YOUR_DB_NAME -e 'SHOW CREATE TABLE tasks\G; SHOW CREATE TABLE subtasks\G'
```

Use an empty test database for schema imports. `database/schema.sql` is an
initial schema, not a repeatable migration.
