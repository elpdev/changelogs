# Changelogs

A Rails application generated with [Boilercode](https://boilercode.io).

## Table of Contents

- [Getting Started](#getting-started)
- [Authentication](#authentication)
- [Admin Dashboard](#admin-dashboard)
- [API](#api)
- [Analytics](#analytics)
- [Utilities](#utilities)
- [Development](#development)
- [Testing](#testing)

## Getting Started

### Requirements

- Ruby 4.0.1+
- SQLite3

### Setup

```bash
bin/setup
```

This installs dependencies, prepares the database, and starts the development server.

### Development

```bash
bin/dev
```

This starts the Rails server and Tailwind CSS watcher.

## Authentication

### User Authentication

This app uses Rails 8's built-in authentication system.

**Default Admin User:**
- Email: `admin@example.com`
- Password: `abc123`

**Creating New Users:**

```ruby
User.create(
  email_address: "user@example.com",
  password: "your-password",
  admin: false
)
```

**Admin Access:**

Admin users have access to protected admin routes. Set `admin: true` on a user to grant admin privileges:

```ruby
user.update(admin: true)
```

## Admin Dashboard

### Admin Panel (Madmin)

The admin panel is available at `/admin` for admin users.

**Features:**
- Auto-generated CRUD interfaces for all models
- Search and filtering capabilities
- Customizable dashboards

**Customizing Admin Resources:**

Admin resources are in `app/madmin/resources/`. To customize a resource:

```ruby
# app/madmin/resources/user_resource.rb
class UserResource < Madmin::Resource
  attribute :id, form: false
  attribute :email_address
  attribute :admin
  attribute :created_at, form: false
end
```

### Job Monitoring (Mission Control)

Monitor and manage background jobs at `/admin/jobs` (or `/jobs` if Madmin is not installed).

**Features:**
- View pending, running, and completed jobs
- Retry failed jobs
- Pause and resume queues
- Real-time job statistics

### Feature Flags (Flipper)

Manage feature flags at `/admin/flipper` (or `/flipper` if Madmin is not installed).

**Usage in Code:**

```ruby
# Check if a feature is enabled
if Flipper.enabled?(:new_dashboard)
  # show new dashboard
end

# Enable for specific users
Flipper.enable(:beta_feature, current_user)

# Enable for a percentage of users
Flipper.enable_percentage_of_actors(:new_feature, 25)
```

**In Views:**

```erb
<% if Flipper.enabled?(:new_feature, current_user) %>
  <%= render "new_feature" %>
<% end %>
```

## API

### API Endpoints

This app includes a versioned JSON API with JWT authentication.

**Authentication Flow:**

1. Create an API key from the web UI at `/api_keys`
2. Request a JWT token:

```bash
curl -X POST http://localhost:3000/api/v1/auth/token \
  -H "Content-Type: application/json" \
  -d '{"client_id": "your_client_id", "secret_key": "your_secret_key"}'
```

3. Use the token in subsequent requests:

```bash
curl http://localhost:3000/api/v1/your_endpoint \
  -H "Authorization: Bearer your_jwt_token"
```

**Creating API Endpoints:**

Add new endpoints in `app/controllers/api/v1/`. Inherit from `Api::V1::BaseController` for automatic JWT authentication:

```ruby
module Api
  module V1
    class UsersController < BaseController
      def index
        render json: User.all
      end
    end
  end
end
```

**Managing API Keys:**

Users can manage their API keys at `/api_keys`. Each key has a client ID and secret key that can be used to obtain JWT tokens.

## Analytics

### Analytics (Ahoy)

Ahoy tracks visits and events in your application.

**Tracking Events:**

```ruby
# In controllers
ahoy.track "Viewed product", product_id: product.id

# In views
<%= ahoy.track "Viewed landing page" %>
```

**Querying Data:**

```ruby
# Recent visits
Ahoy::Visit.last(10)

# Events for a specific action
Ahoy::Event.where(name: "Viewed product")
```

**Configuration:**

Customize tracking in `config/initializers/ahoy.rb`.

## Utilities

### Pagination (Pagy)

Pagy is configured for efficient pagination.

**In Controllers:**

```ruby
def index
  @pagy, @users = pagy(User.all)
end
```

**In Views:**

```erb
<%= pagy_nav(@pagy) %>
```

**Customizing:**

```ruby
# Change items per page
@pagy, @users = pagy(User.all, limit: 25)
```

### Column Sorting

Sortable columns are available in index views.

**In Controllers:**

```ruby
def index
  @users = apply_order(User.all)
end
```

**In Views:**

```erb
<th><%= sort_link("Name", :name) %></th>
<th><%= sort_link("Created", :created_at) %></th>
```

**Allowed Columns:**

By default, sorting is allowed on any column. To restrict:

```ruby
def orderable_columns
  %w[name email created_at]
end
```

### Search (Ransack)

Object-based searching using [Ransack](https://github.com/activerecord-hackery/ransack) with a `Searchable` controller concern and a reusable search form partial.

**Controller (using the Searchable concern):**

```ruby
class PostsController < ApplicationController
  def index
    @posts = search(Post)
  end
end
```

The `search` method sets `@q` for the view and returns filtered results. It's available in all controllers via `ApplicationController`.

**Search Form in Views:**

```erb
<%= render "search_form", q: @q, url: posts_path, field: :title_cont, placeholder: "Search posts..." %>
```

The `_search_form` partial renders a styled search input with a search icon. Pass any Ransack predicate as the `field` parameter.

**Common Predicates:**

| Predicate | Meaning |
|-----------|---------|
| `_cont` | Contains |
| `_eq` | Equals |
| `_gteq` | Greater than or equal |
| `_lteq` | Less than or equal |
| `_start` | Starts with |
| `_end` | Ends with |
| `_present` | Is not null/blank |

**Combining with Pagy:**

```ruby
def index
  results = search(Post)
  @pagy, @posts = pagy(results)
end
```

### Notifications (Noticed)

In-app notifications using [Noticed](https://github.com/excid3/noticed). Includes a notification bell in the navbar and a notifications page.

**Creating a Notifier:**

```ruby
# app/notifiers/comment_notifier.rb
class CommentNotifier < Noticed::Event
  deliver_by :action_cable do |config|
    config.channel = "NotificationsChannel"
  end

  notification_methods do
    def message
      "#{params[:user].name} commented on your post."
    end

    def url
      post_path(params[:post])
    end
  end
end
```

**Sending a Notification:**

```ruby
CommentNotifier.with(record: @comment, user: current_user).deliver(@post.author)
```

**In Controllers:**

```ruby
# Mark single notification as read
notification.mark_as_read!

# Get unread notifications
current_user.notifications.unread

# Mark all as read
current_user.notifications.unread.mark_as_read!
```

**Notifications Page:** Visit `/notifications` to see all notifications with read/unread state.

### SEO (Meta Tags + Sitemap)

Per-page meta tags using [meta-tags](https://github.com/kpumuk/meta-tags) and XML sitemap generation using [sitemap_generator](https://github.com/kjvarga/sitemap_generator).

**Setting Meta Tags Per Page:**

```ruby
# In a controller action
def show
  @post = Post.find(params[:id])
  set_meta_tags(
    title: @post.title,
    description: @post.excerpt,
    og: { title: @post.title, image: @post.cover_url }
  )
end
```

**Or in views:**

```erb
<% title "About Us" %>
<% description "Learn more about our company." %>
```

**Default meta tags** are set automatically via the `DefaultMetaTags` concern in `ApplicationController`. Override them per-page as needed.

**Generating a Sitemap:**

```bash
rails sitemap:refresh           # Generate and ping search engines
rails sitemap:refresh:no_ping   # Generate without pinging
```

Configure routes in `config/sitemap.rb`.

### Markdown Rendering

Markdown is rendered using [Commonmarker](https://github.com/gjtorikian/commonmarker) (Rust-based, GFM-compliant) with syntax-highlighted code blocks.

**In views (helper):**

```erb
<%= render_markdown("# Hello **world**") %>

<%= render_markdown(@article.body) %>
```

**With ViewComponent (if enabled):**

```erb
<%= render(Markdown::Component.new(text: @article.body)) %>

<%# With a block: %>
<%= render(Markdown::Component.new) do %>
  # Hello **world**
<% end %>

<%# Override theme: %>
<%= render(Markdown::Component.new(text: @content, theme: "InspiredGitHub")) %>
```

**Configuration:** `config/initializers/commonmarker.rb` controls default parse/render options and the syntax highlight theme.

## Development

### Email Previews (Letter Opener)

All emails sent in development are caught and viewable at [/letter_opener](http://localhost:3000/letter_opener) instead of being delivered.

No configuration needed — just send an email from your app and visit `/letter_opener` to see it.

## Testing

### Running Tests

```bash
# Run all tests
bin/rspec

# Run specific file
bin/rspec spec/models/user_spec.rb

# Run specific test by line number
bin/rspec spec/models/user_spec.rb:42
```

**Test Helpers:**

FactoryBot is available for creating test data:

```ruby
# Create a user
user = create(:user)

# Build without saving
user = build(:user, email_address: "custom@example.com")
```

Shoulda Matchers are available for concise model tests:

```ruby
RSpec.describe User, type: :model do
  it { should validate_presence_of(:email_address) }
  it { should have_many(:api_keys) }
end
```

---

Generated with [Boilercode](https://boilercode.io)
