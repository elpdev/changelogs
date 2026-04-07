# Articles API

Manage news articles about open source projects.

## List Articles

```
GET /api/v1/articles
```

### Query Parameters

| Parameter | Description |
|-----------|-------------|
| `project_id` | Filter articles by project ID |

### Response (200 OK)

```json
[
  {
    "id": 1,
    "title": "Rails 8.1 Released",
    "slug": "rails-8-1-released",
    "summary": "Rails 8.1 brings exciting new features...",
    "content": "## What's New\n\nRails 8.1 includes...",
    "published_at": "2026-04-07T10:00:00.000Z",
    "created_at": "2026-04-07T09:00:00.000Z",
    "updated_at": "2026-04-07T10:00:00.000Z",
    "published": true,
    "reading_time": 3,
    "project": {
      "id": 1,
      "name": "Rails",
      "slug": "rails",
      "language": "Ruby"
    }
  }
]
```

## Get an Article

```
GET /api/v1/articles/:slug
```

### Response (200 OK)

Same shape as a single item in the list response.

### Errors

- `404 Not Found` - Article with that slug does not exist

## Create an Article

```
POST /api/v1/articles
```

### Request

```json
{
  "article": {
    "project_id": 1,
    "title": "Rails 8.1 Released",
    "summary": "Rails 8.1 brings exciting new features...",
    "content": "## What's New\n\nRails 8.1 includes several improvements..."
  }
}
```

Required fields: `project_id`, `title`, `content`

Optional fields: `summary`, `published_at`

The `slug` is auto-generated from `title`.

Articles are created as **drafts** by default (no `published_at`). To publish immediately, include `published_at`.

### Response (201 Created)

Returns the created article.

### Errors

- `422 Unprocessable Content` - Validation errors

## Update an Article

```
PATCH /api/v1/articles/:slug
```

### Request

```json
{
  "article": {
    "title": "Updated Title",
    "content": "Updated content..."
  }
}
```

Only include the fields you want to update.

### Response (200 OK)

Returns the updated article.

## Delete an Article

```
DELETE /api/v1/articles/:slug
```

### Response (204 No Content)

No response body.

## Publishing Workflow

Articles follow a draft-to-published workflow:

### 1. Create a draft

```bash
curl -X POST https://changelogs.news/api/v1/articles \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "article": {
      "project_id": 1,
      "title": "What is New in Rails 8.1",
      "summary": "A look at the latest Rails release",
      "content": "## Overview\n\nRails 8.1 ships with..."
    }
  }'
```

### 2. Publish the article

Set `published_at` to make it live on the site:

```bash
curl -X PATCH https://changelogs.news/api/v1/articles/what-is-new-in-rails-8-1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "article": {
      "published_at": "2026-04-07T12:00:00Z"
    }
  }'
```

### 3. Schedule for later

Set `published_at` to a future date. The article will appear on the site once that time passes:

```bash
curl -X PATCH https://changelogs.news/api/v1/articles/what-is-new-in-rails-8-1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "article": {
      "published_at": "2026-04-10T09:00:00Z"
    }
  }'
```

### 4. Unpublish (revert to draft)

Set `published_at` to `null`:

```bash
curl -X PATCH https://changelogs.news/api/v1/articles/what-is-new-in-rails-8-1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "article": {
      "published_at": null
    }
  }'
```
