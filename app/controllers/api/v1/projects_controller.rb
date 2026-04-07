class API::V1::ProjectsController < API::V1::BaseController
  before_action :set_project, only: [:show, :update, :destroy]

  def index
    @projects = Project.order(created_at: :desc)
  end

  def show
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      render :show, status: :created
    else
      render_error(@project.errors.full_messages.join(", "))
    end
  end

  def update
    if @project.update(project_params)
      render :show
    else
      render_error(@project.errors.full_messages.join(", "))
    end
  end

  def destroy
    @project.destroy
    head :no_content
  end

  private

  def set_project
    @project = Project.find_by!(slug: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Project not found"}, status: :not_found
  end

  def project_params
    params.require(:project).permit(
      :name, :description, :github_url, :language,
      :stars_count, :last_synced_at
    )
  end
end
