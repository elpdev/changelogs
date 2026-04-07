module PublicPage
  extend ActiveSupport::Concern

  included do
    allow_unauthenticated_access
    layout "public"
  end
end
