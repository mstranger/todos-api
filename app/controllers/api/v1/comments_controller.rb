class Api::V1::CommentsController < Api::V1::ApiController
  resource_description do
    api_versions "v1"
    short "Task comments"
    error 401, "Need to login first"
  end

  api! "Comments list"
  #
  def index
    @project = Project.find(params[:project_id])

    if @project.user == @current_user
      @task = Task.find(params[:task_id])

      if @task.project == @project
        @comments = @task.comments
      else
        render json: t("user.errors.not_permitted"), status: :unauthorized
      end
    else
      render json: t("user.errors.not_permitted"), status: :forbidden
    end
  end

  api! "Add a new comment"
  #
  def create
    @project = Project.find(params[:project_id])

    if @project.user == @current_user
      @task = Task.find(params[:task_id])

      if @task.project == @project
        @comment = Comment.new(comment_params)
        @comment.save!

        render json: :ok, status: :created
      else
        render json: t("user.errors.not_permitted"), status: :unauthorized
      end
    else
      render json: t("user.errors.not_permitted"), status: :forbidden
    end
  end

  api! "Delete a comment"
  #
  def destroy
    @project = Project.find(params[:project_id])

    if @project.user == @current_user
      @task = Task.find(params[:task_id])

      if @task.project == @project
        @comment = Comment.find(params[:id])
        @comment.destroy

        render json: :ok
      else
        render json: t("user.errors.not_permitted"), status: :unauthorized
      end
    else
      render json: t("user.errors.not_permitted"), status: :forbidden
    end
  end

  private

  def comment_params
    params.require(:data)
          .permit(:content)
          .merge(user_id: @current_user.id, task_id: @task.id)
  end
end
