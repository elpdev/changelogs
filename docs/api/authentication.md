# Authentication

The API uses JWT (JSON Web Token) authentication. Tokens are obtained by exchanging API key credentials.

## Step 1: Create an API Key

Sign in to the web UI and navigate to **API Keys** to create a new key. You will receive:

- `client_id` - A unique identifier (starts with `bc_`)
- `secret_key` - A secret key (shown only once at creation time)

Store both values securely.

## Step 2: Get a JWT Token

Exchange your API key credentials for a JWT token:

```
POST /api/v1/auth/token
```

### Request

```json
{
  "client_id": "bc_abc123...",
  "secret_key": "your_secret_key"
}
```

### Response (200 OK)

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "expires_in": 3600
}
```

### Errors

- `401 Unauthorized` - Invalid credentials
- `401 Unauthorized` - API key has expired

## Step 3: Use the Token

Include the token in the `Authorization` header of all subsequent requests:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

## Token Expiration

Tokens expire after **1 hour** (3600 seconds). When a token expires, request a new one using Step 2.

## Example (curl)

```bash
# Get a token
TOKEN=$(curl -s -X POST https://changelogs.news/api/v1/auth/token \
  -H "Content-Type: application/json" \
  -d '{"client_id":"bc_abc123","secret_key":"your_secret"}' \
  | jq -r '.token')

# Use the token
curl -s https://changelogs.news/api/v1/projects \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json"
```
