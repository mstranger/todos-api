class Api::V1::TasksController < Api::V1::ApiController
  # resource_description do
  #   api_versions "v1"
  #   app_info ""
  #   short "Todos actions"
  #   error 404, "Missing"
  # end

  # def_param_group :data do
  #   param :data, Hash, required: true do
  #     param :title, String, "What are we going to do", required: true
  #   end
  # end

  # api! "All tasks"
  #
  def index
    @project = Project.find(params[:project_id])

    unless @project.user == @current_user
      render json: t("user.errors.not_permitted"), status: :forbidden
    end

    @tasks = @project.tasks
  end

  # api! "Show task"
  # param :id, :number, required: true
  #
  def show
    @project = Project.find(params[:project_id])

    unless @project.user == @current_user
      render json: t("user.errors.not_permitted"), status: :forbidden
    end

    @task = Task.find(params[:id])

    unless @task.project == @project
      render json: t("project.errors.not_permitted"), status: :unauthorized
    end
  end

  # api! "Create new task"
  # param_group :data
  #
  def create
    @project = Project.find(params[:project_id])

    if @project.user == @current_user
      @task = Task.new(task_params.merge(project_id: @project.id))
      @task.save!

      render json: :ok, status: :created
    else
      render json: t("user.errors.not_permitted"), status: :forbidden
    end
  end

  # api! "Update task"
  # param :id, :number, required: true
  # param_group :data
  #
  def update
    @project = Project.find(params[:project_id])

    if @project.user == @current_user
      @task = Task.find(params[:id])

      if @task.project == @project
        @task.update!(task_params)
        render json: :ok
      else
        render json: t("user.errors.not_permitted"), status: :unauthorized
      end
    else
      render json: t("user.errors.not_permitted"), status: :forbidden
    end
  end

  # api! "Delete task"
  # param :id, :number, required: true
  #
  def destroy
    @project = Project.find(params[:project_id])
    if @project.user == @current_user
      @task = Task.find(params[:id])

      if @task.project == @project
        @task.destroy
        render json: :ok
      else
        render json: t("user.errors.not_permitted"), status: :unauthorized
      end
    else
      render json: t("user.errors.not_permitted"), status: :forbidden
    end
  end

  # api! "Toggle completed"
  # param :id, :number, required: true
  #
  def toggle
    @project = Project.find(params[:project_id])
    if @project.user == @current_user
      @task = Task.find(params[:id])

      if @task.project == @project
        @task.update(completed: !@task.completed)
      else
        render json: t("user.errors.not_permitted"), status: :unauthorized
      end
    else
      render json: t("user.errors.not_permitted"), status: :forbidden
    end
  end

  private

  def task_params
    params.require(:data).permit!
  end
end
