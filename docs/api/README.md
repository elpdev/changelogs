# changelogs.news API

Base URL: `https://changelogs.news/api/v1`

All API requests require JWT authentication. See [Authentication](authentication.md) for details.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | /api/v1/auth/token | Get a JWT token |
| GET | /api/v1/projects | List all projects |
| GET | /api/v1/projects/:slug | Get a project |
| POST | /api/v1/projects | Create a project |
| PATCH | /api/v1/projects/:slug | Update a project |
| DELETE | /api/v1/projects/:slug | Delete a project |
| GET | /api/v1/articles | List all articles |
| GET | /api/v1/articles/:slug | Get an article |
| POST | /api/v1/articles | Create an article |
| PATCH | /api/v1/articles/:slug | Update an article |
| DELETE | /api/v1/articles/:slug | Delete an article |

## Error Responses

All errors return JSON in this format:

```json
{
  "error": "Description of what went wrong"
}
```

Common status codes:

- `401 Unauthorized` - Missing or invalid JWT token
- `404 Not Found` - Resource does not exist
- `422 Unprocessable Content` - Validation errors

## Resources

- [Authentication](authentication.md)
- [Projects API](projects.md)
- [Articles API](articles.md)
