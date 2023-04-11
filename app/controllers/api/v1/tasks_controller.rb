class Api::V1::TasksController < Api::V1::ApiController
  # resource_description do
  #   short "Site members"
  #   formats ['json']
  #   param :id, Integer, :desc => "User ID", :required => false
  #   param :resource_param, Hash, :desc => 'Param description for all methods' do
  #     param :ausername, String, :desc => "Username for login", :required => true
  #     param :apassword, String, :desc => "Password for login", :required => true
  #   end
  #   api_version "development"
  #   error 404, "Missing"
  #   error 500, "Server crashed for some <%= reason %>", :meta => {:anything => "you can think of"}
  #   error :unprocessable_entity, "Could not save the entity."
  #   returns :code => 403 do
  #     property :reason, String, :desc => "Why this was forbidden"
  #   end
  #   meta :author => {:name => 'John', :surname => 'Doe'}
  #   deprecated false
  # end

  def_param_group :address do
    param :street, String, "Street name"
    param :number, Integer
    param :zip, String
  end

  def_param_group :user do
    param :user, Hash, :required => true, :action_aware => true do
      param :name, String, "Name of the user", :required => true
      param_group :address
    end
  end

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  skip_before_action :authenticate_request, only: [:index]

  api!
  def index
    @tasks = Task.all
  end

  # api :GET, "/v1/tasks/:id"
  # param :id, :number, desc: "id of the requested task"
  api!
  def show
    @task = Task.find(params[:id])
  end

  api!
  def create
    @task = Task.new(task_params)
    @task.save!

    render json: :ok, status: :created
  end

  api!
  def update
    @task = Task.find(params[:id])
    @task.update!(task_params)

    render json: :ok
  end

  api!
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
