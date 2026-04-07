# Projects API

Manage open source projects tracked by changelogs.news.

## List Projects

```
GET /api/v1/projects
```

### Response (200 OK)

```json
[
  {
    "id": 1,
    "name": "Rails",
    "slug": "rails",
    "description": "Ruby on Rails web framework",
    "github_url": "https://github.com/rails/rails",
    "language": "Ruby",
    "stars_count": 56000,
    "articles_count": 12,
    "last_synced_at": "2026-04-07T12:00:00.000Z",
    "created_at": "2026-04-01T00:00:00.000Z",
    "updated_at": "2026-04-07T12:00:00.000Z"
  }
]
```

## Get a Project

```
GET /api/v1/projects/:slug
```

### Response (200 OK)

Same shape as a single item in the list response.

### Errors

- `404 Not Found` - Project with that slug does not exist

## Create a Project

```
POST /api/v1/projects
```

### Request

```json
{
  "project": {
    "name": "Rails",
    "description": "Ruby on Rails web framework",
    "github_url": "https://github.com/rails/rails",
    "language": "Ruby",
    "stars_count": 56000
  }
}
```

Required fields: `name`, `github_url`

Optional fields: `description`, `language`, `stars_count`, `last_synced_at`

The `slug` is auto-generated from `name` (e.g., "Rails" becomes "rails").

### Response (201 Created)

Returns the created project.

### Errors

- `422 Unprocessable Content` - Validation errors (e.g., duplicate github_url)

## Update a Project

```
PATCH /api/v1/projects/:slug
```

### Request

```json
{
  "project": {
    "stars_count": 57000,
    "last_synced_at": "2026-04-07T15:00:00.000Z"
  }
}
```

Only include the fields you want to update.

### Response (200 OK)

Returns the updated project.

## Delete a Project

```
DELETE /api/v1/projects/:slug
```

This also deletes all articles belonging to the project.

### Response (204 No Content)

No response body.
