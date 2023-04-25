class Api::V1::ProjectsController < Api::V1::ApiController
  before_action :find_project, only: [:show, :update, :destroy]

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
  end

  api! "Show project"
  param_group :jwt_info
  param_group :with_id
  #
  def show
    render json: t("project.errors.not_permitted"),
           status: :forbidden unless @project.user == @current_user
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
    return render json: t("project.errors.not_permitted"),
           status: :forbidden unless @project.user == @current_user

    @project.update!(project_params)

    render json: :ok
  end

  api! "Delete project"
  param_group :jwt_info
  param_group :with_id
  #
  def destroy
    return render json: t("project.errors.not_permitted"),
           status: :forbidden unless @project.user == @current_user

    @project.destroy

    render json: :ok
  end

  private

  def project_params
    params.require(:data).permit(:name)
  end

  def find_project
    @project = Project.find(params[:id])
  end
end
