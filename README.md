# Machsbald

A deliberately minimal private single-user todo web application.

Entering a task is nearly frictionless: type text, press Enter, done.

## Status

Phase 1 — foundation: schema, configuration and webserver layout. The task UI
is not implemented yet.

## Scope

See [docs/PROJECT_SCOPE.md](docs/PROJECT_SCOPE.md) for the full product scope,
scheduling categories, subtask model, UI interaction requirements, explicit
non-goals and technical constraints.

## Development

- Stack target: PHP 8.5, MySQL 8.4, HTML5, CSS, modern JavaScript (`fetch`/JSON).
- Database configuration is external/configurable; no Netcup-specific paths,
  hosts or credentials are baked into the code.
- See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for local setup and
  [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) for deployment.
