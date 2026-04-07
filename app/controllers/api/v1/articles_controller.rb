class API::V1::ArticlesController < API::V1::BaseController
  before_action :set_article, only: [:show, :update, :destroy]

  def index
    @articles = Article.includes(:project).order(created_at: :desc)
    @articles = @articles.where(project_id: params[:project_id]) if params[:project_id].present?
  end

  def show
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      render :show, status: :created
    else
      render_error(@article.errors.full_messages.join(", "))
    end
  end

  def update
    if @article.update(article_params)
      render :show
    else
      render_error(@article.errors.full_messages.join(", "))
    end
  end

  def destroy
    @article.destroy
    head :no_content
  end

  private

  def set_article
    @article = Article.find_by!(slug: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Article not found"}, status: :not_found
  end

  def article_params
    params.require(:article).permit(
      :project_id, :title, :summary, :content, :published_at
    )
  end
end
