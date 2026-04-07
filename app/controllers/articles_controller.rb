class ArticlesController < ApplicationController
  include PublicPage

  def show
    @article = Article.published.includes(:project).find_by!(slug: params[:slug])
    set_meta_tags(
      title: @article.title,
      description: @article.summary.to_s.truncate(160),
      og: {
        title: @article.title,
        description: @article.summary.to_s.truncate(160),
        type: "article",
        article: {
          published_time: @article.published_at&.iso8601,
          section: @article.project.name
        }
      }
    )
  end
end
