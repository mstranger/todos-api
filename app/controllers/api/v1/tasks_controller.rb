class Api::V1::TasksController < Api::V1::ApiController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  resource_description do
    api_versions "v1"
    app_info ""
    short "Todos actions"
    error 404, "Missing"
  end

  def_param_group :data do
    param :data, Hash, required: true do
      param :title, String, "What are we going to do", required: true
    end
  end

  api! "All tasks"
  #
  def index
    @tasks = Task.where(user_id: @current_user.id)
  end

  api! "Show task"
  param :id, :number, required: true
  #
  def show
    @task = Task.find(params[:id])

    unless @task.user == @current_user
      render json: t("user.errors.not_permitted"), status: :unauthorized
    end
  end

  api! "Create new task"
  param_group :data
  #
  def create
    @task = Task.new(task_params.merge(user_id: @current_user.id))
    @task.save!

    render json: :ok, status: :created
  end

  api! "Update task"
  param :id, :number, required: true
  param_group :data
  #
  def update
    @task = Task.find(params[:id])

    if @task.user == @current_user
      @task.update!(task_params)
      render json: :ok
    else
      render json: t("user.errors.not_permitted"), status: :unauthorized
    end
  end

  api! "Delete task"
  param :id, :number, required: true
  #
  def destroy
    @task = Task.find(params[:id])

    if @task.user == @current_user
      @task.destroy
      render json: :ok
    else
      render json: t("user.errors.not_permitted"), status: :unauthorized
    end
  end

  private

  def task_params
    params.require(:data).permit!
  end

  def record_not_found
    render json: { error: t("user.errors.not_found") }, status: :not_found
  end

  def record_invalid
    render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
  end
end
