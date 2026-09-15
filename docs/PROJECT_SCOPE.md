# Machsbald — Project Scope

A deliberately minimal private single-user todo web application.

## Core principle

Entering a task must be nearly frictionless: type text, press Enter, done.

## A task has

- Text
- Urgency/scheduling category
- Optional free-text details
- Optional flat checklist/subtasks
- Done / not-done state

## Scheduling categories

- Eigentlich gestern — **default**
- ASAP
- Fixes Datum
- Diese Woche
- Irgendwann
- Wenn mir langweilig ist

## Subtasks

Subtasks are simple checklist items only:

- Text
- Order
- Done / not done

They inherit the parent task's urgency. They have no own dates, priorities,
dependencies or nested subtasks. Completed checklist items are displayed below
open ones without losing their original ordering.

## UI interaction

- `Enter` = save and finish
- `Shift+Enter` = save and immediately enter another item
- Existing tasks have `+` for adding checklist items
- Clicking a task opens/closes its details
- Checking an item must **not** close the currently opened task
- Interactions should not require full-page reloads

## Explicit non-goals

Do **not** add:

- Users / accounts
- Registration
- Teams
- Projects
- Kanban
- Sprints
- Tags
- Story points
- Dependency graphs
- Nested subtasks
- SaaS functionality

Authentication is outside the application via webserver `.htaccess` / HTTP
authentication.

## Technical constraints

Production currently provides PHP 8.5.9 and MySQL 8.4.11.

V1 should target:

- PHP
- MySQL
- HTML5
- CSS
- modern JavaScript
- dynamic interactions via `fetch` / JSON where appropriate

Do not bake Netcup-specific paths, hosts or credentials into application code.
Database configuration must be external/configurable. Docker is **not**
required, but avoid decisions that unnecessarily prevent later
self-hosting/containerization.
