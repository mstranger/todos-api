class Api::V1::TasksController < Api::V1::ApiController
  def index
    # response.set_header("Content-Type", "application/vnd.api+json")

    @tasks = Task.all
  end

  def show
    # response.set_header("Content-Type", "application/vnd.api+json")

    @task = Task.find(params[:id])
  end

  def create
    # puts "----"
    # pp task_params
    # puts "----"

    @task = Task.new(task_params)
    if @task.save
      render json: { result: :success }, status: :created
    else
      render json: { result: :fail, errors: @task.errors.full_messages }, status: :unprocessable_entity
    end

    # debugger
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
