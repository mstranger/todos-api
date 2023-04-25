class Api::V1::CommentsController < Api::V1::ApiController
  before_action :find_resources

  resource_description do
    api_versions "v1"
    short "Task comments"
    error 401, "Need to login first"
    error 403, "No access to perform action"
    error 404, "Missing entity"
  end

  def_param_group :with_ids do
    param :project_id, :number, required: true
    param :task_id, :number, required: true
  end

  api! "Comments list"
  param_group :with_ids
  error 403, "No access to perform action"
  error 404, "Missing entity"
  #
  def index
    @comments = @task.comments
  end

  api! "Add a new comment"
  param_group :with_ids
  param :data, Hash, required: true do
    param :content, String, required: true
  end
  error 422, "Invalid request data"
  #
  def create
    @comment = Comment.new(comment_params)
    @comment.save!

    render json: :ok, status: :created
  end

  api! "Delete a comment"
  param_group :with_ids
  param :id, :number, required: true
  #
  def destroy
    @comment = Comment.find(params[:id])

    return render json: t("user.errors.not_permitted"),
           status: :forbidden unless @comment.task == @task

    @comment.destroy

    render json: :ok
  end

  private

  def comment_params
    params.require(:data)
          .permit(:content)
          .merge(user_id: @current_user.id, task_id: @task.id)
  end

  def find_resources
    @project = Project.find(params[:project_id])

    return render json: t("user.errors.not_permitted"),
           status: :forbidden unless @project.user == @current_user

    @task = Task.find(params[:task_id])

    return render json: t("user.errors.not_permitted"),
           status: :unauthorized unless @task.project == @project
  end
end
