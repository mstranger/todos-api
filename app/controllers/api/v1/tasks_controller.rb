class Api::V1::TasksController < Api::V1::ApiController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    @task.save!

    render json: { result: :success }, status: :created
  rescue ActiveRecord::RecordInvalid
    render json: { result: :fail, errors: @task.errors.full_messages }, status: :unprocessable_entity
  end

  def update
    @task = Task.find(params[:id])
    @task.update!(task_params)

    render json: { result: :success }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { result: :fail }, status: :not_found
  rescue ActiveRecord::RecordInvalid
    render json: { result: :fail, errors: @task.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    render json: { result: :success }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { result: :fail }, status: :not_found
  end

  private

  def task_params
    params.require(:data).permit!
  end
end
