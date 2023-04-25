class Api::V1::TasksController < Api::V1::ApiController
  before_action :find_project

  # NOTE: it seems inheritance is not working for now
  # see https://github.com/Apipie/apipie-rails/issues/488

  resource_description do
    api_versions "v1"
    app_info ""
    short "Tasks actions"
    error 401, "Need to login first"
    error 403, "No access to perform action"
    error 404, "Missing entity"
  end

  def_param_group :jwt_info do
    description "Use JWT token for user authentication"
    example "'Authorization' => 'HS256 foo.bar.token'"
  end

  def_param_group :both_ids do
    param :id, :number, required: true
    param :project_id, :number, required: true
  end

  def_param_group :data do
    param :data, Hash, required: true do
      param :title, String, "What are you going to do", required: true
    end
  end

  api! "All tasks"
  param_group :jwt_info
  param :project_id, :number, required: true
  #
  def index
    @tasks = @project.tasks
  end

  api! "Show task"
  param_group :jwt_info
  param_group :both_ids
  #
  def show
    @task = Task.find(params[:id])

    render json: t("project.errors.not_permitted"),
           status: :unauthorized unless @task.project == @project
  end

  api! "Create new task"
  param :project_id, :number, required: true
  param_group :jwt_info
  param_group :data
  error 422, "Invalid request data"
  #
  def create
    @task = Task.new(task_params.merge(project_id: @project.id))
    @task.save!

    render json: :ok, status: :created
  end

  api! "Update task"
  param_group :jwt_info
  param_group :both_ids
  param_group :data
  error 422, "Invalid request data"
  #
  def update
    @task = Task.find(params[:id])

    return render json: t("user.errors.not_permitted"),
           status: :unauthorized unless @task.project == @project

    @task.update!(task_params)

    render json: :ok
  end

  api! "Delete task"
  param_group :jwt_info
  param_group :both_ids
  #
  def destroy
    @task = Task.find(params[:id])

    return render json: t("user.errors.not_permitted"),
           status: :unauthorized unless @task.project == @project

    @task.destroy

    render json: :ok
  end

  api! "Toggle completed"
  param_group :jwt_info
  param_group :both_ids
  #
  def toggle
    @task = Task.find(params[:id])

    return render json: t("user.errors.not_permitted"),
           status: :unauthorized unless @task.project == @project

    @task.update(completed: !@task.completed)
  end

  private

  def task_params
    params.require(:data).permit!
  end

  def find_project
    @project = Project.find(params[:project_id])

    return render json: t("user.errors.not_permitted"),
           status: :forbidden unless @project.user == @current_user
  end
end
