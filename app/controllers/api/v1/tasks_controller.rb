class Api::V1::TasksController < Api::V1::ApiController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  skip_before_action :authenticate_request, only: [:index]

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
    @tasks = Task.all
  end

  api! "Show task"
  param :id, :number, required: true
  #
  def show
    @task = Task.find(params[:id])
  end

  api! "Create new task"
  param_group :data
  #
  def create
    @task = Task.new(task_params)
    @task.save!

    render json: :ok, status: :created
  end

  api! "Update task"
  param :id, :number, required: true
  param_group :data
  #
  def update
    @task = Task.find(params[:id])
    @task.update!(task_params)

    render json: :ok
  end

  api! "Delete task"
  param :id, :number, required: true
  #
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    render json: :ok
  end

  private

  def task_params
    params.require(:data).permit!
  end

  def record_not_found
    render json: { error: "Record not found" }, status: :not_found
  end

  def record_invalid
    render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
  end
end
