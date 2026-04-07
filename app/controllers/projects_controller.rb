class ProjectsController < ApplicationController
  include PublicPage

  def index
    @q = Project.ransack(params[:q])
    @pagy, @projects = pagy(@q.result(distinct: true).by_popularity, limit: 24)
    set_meta_tags(
      title: "Projects",
      description: "Open source projects tracked by changelogs.news"
    )
  end

  def show
    @project = Project.find_by!(slug: params[:slug])
    @pagy, @articles = pagy(@project.articles.recent, limit: 20)
    set_meta_tags(
      title: @project.name,
      description: @project.description.to_s.truncate(160),
      og: {
        title: "#{@project.name} - changelogs.news",
        description: @project.description.to_s.truncate(160)
      }
    )
  end
end
