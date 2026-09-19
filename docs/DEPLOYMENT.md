# Netcup deployment

Deploy Phase 1 as an Apache/PHP application with `public/` as the document
root. The page is a placeholder until later phases implement the task UI.

1. Confirm the selected hosting environment provides PHP 8.5, `pdo_mysql`,
   MySQL 8.4 and Apache 2.4 `.htaccess` support. Enable PHP error logging and
   disable public error display.
2. Upload the repository contents outside the document root. Point the domain
   or subdomain document root at its `public/` directory. Check that source,
   `config/`, `database/`, `docs/` and `.git` are not web accessible.
3. Create a dedicated MySQL database and user through the hosting control
   panel. Import `database/schema.sql` once into the empty database. Do not
   grant that user access to unrelated databases.
4. Copy `config/database.example.php` to an unversioned PHP file outside the
   document root and fill in the actual connection values. Either place it at
   `config/database.local.php`, or set `MACHSBALD_DB_CONFIG` to its absolute
   path in the PHP runtime environment. Verify that the chosen hosting PHP
   handler passes the variable to PHP before relying on the external path.
   Restrict read access to the PHP process and administrators.
5. Create an HTTP Basic Authentication password file outside the document
   root using `htpasswd`. Copy `server/apache-public.htaccess.example` to
   `public/.htaccess` and replace the example `AuthUserFile` with the real
   absolute password-file path. Keep both files out of version control.
   Configure Apache to honor the required `.htaccess` overrides.
6. Use HTTPS for the site. Verify an unauthenticated request returns `401`,
   an authenticated request reaches the placeholder, and requests for source
   or configuration files cannot succeed. Verify PHP logs remain private.

No Netcup hostnames, account paths or credentials are required in application
code. The deployment chooses the document root, configuration location and
password-file location. The committed root `.htaccess` blocks an accidental
project-root document root, but `public/` must still be selected explicitly.

After deploying a later phase, apply its database migrations or deployment
instructions before switching traffic. This initial schema is not a migration
runner.
