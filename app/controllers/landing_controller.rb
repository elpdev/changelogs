class LandingController < ApplicationController
  include PublicPage

  def show
    @pagy, @articles = pagy(Article.recent.includes(:project), limit: 15)
    set_meta_tags(
      title: "Developer news from the open source world",
      description: "changelogs.news tracks the latest releases, updates, and news from open source projects.",
      og: {
        title: "changelogs.news",
        description: "Developer news from the open source world",
        type: "website"
      }
    )
  end
end
