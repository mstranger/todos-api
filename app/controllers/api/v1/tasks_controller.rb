class Api::V1::TasksController < Api::V1::ApiController
  def index
    # response.set_header("Content-Type", "application/vnd.api+json")

    @tasks = Task.all
  end

  def show
    # response.set_header("Content-Type", "application/vnd.api+json")

    @task = Task.find(params[:id])
  end
end
