class Api::V1::ProjectsController < Api::V1::ApiController
  before_action :find_project, only: %i[show update destroy]

  resource_description do
    api_versions "v1"
    short "Projects actions"
    error 401, "Need to login first"
  end

  def_param_group :with_id do
    param :id, :number, required: true
    error 403, "No access to perform action"
    error 404, "Missing entity"
  end

  def_param_group :data do
    param :data, Hash, required: true do
      param :name, String, "Project title", required: true
    end
    error 422, "Invalid request data"
  end

  def_param_group :jwt_info do
    description "Use JWT token for user authentication"
    example "'Authorization' => 'HS256 foo.bar.token'"
  end

  api! "All projects"
  param_group :jwt_info
  #
  def index
    @projects = Project.where(user_id: @current_user.id)
                       .order(:created_at)
                       .includes(%i[user tasks])
  end

  api! "Show project"
  param_group :jwt_info
  param_group :with_id
  #
  def show
    return if @project.user == @current_user

    render json: t("project.errors.not_permitted"), status: :forbidden
  end

  api! "Create new project"
  param_group :jwt_info
  param_group :data
  #
  def create
    @project = Project.new(project_params.merge(user_id: @current_user.id))
    @project.save!
    render json: :ok, status: :created
  end

  api! "Update project"
  param_group :jwt_info
  param_group :with_id
  param_group :data
  #
  def update
    if @project.user == @current_user
      @project.update!(project_params)
      render json: :ok
    else
      render json: t("project.errors.not_permitted"), status: :forbidden
    end
  end

  api! "Delete project"
  param_group :jwt_info
  param_group :with_id
  #
  def destroy
    if @project.user == @current_user
      @project.destroy
      render json: :ok
    else
      render json: t("project.errors.not_permitted"), status: :forbidden
    end
  end

  private

  def project_params
    params.require(:data).permit(:name)
  end

  def find_project
    @project = Project.find(params[:id])
  end
end
