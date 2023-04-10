class Api::V1::TasksController < Api::V1::ApiController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  skip_before_action :authenticate_request, only: [:index]

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    @task.save!

    render json: :ok, status: :created
  end

  def update
    @task = Task.find(params[:id])
    @task.update!(task_params)

    render json: :ok
  end

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
