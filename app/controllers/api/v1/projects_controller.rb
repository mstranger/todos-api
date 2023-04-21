class Api::V1::ProjectsController < ApplicationController
  def index
    @projects = Project.where(user_id: @current_user.id)
  end

  def show
    @project = Project.find(params[:id])

    unless @project.user == @current_user
      render json: t("user.errors.not_permitted"), status: :unauthorized
    end
  end

  def create
    project = Project.new(project_params)
    project.user = @current_user
    project.save!

    render json: :ok, status: :created
  end

  def update
    project = Project.find(params[:id])

    if project.user == @current_user
      project.update!(project_params)
      render json: :ok
    else
      render json: t("user.errors.not_permitted"), status: :unauthorized
    end
  end

  def destroy
    project = Project.find(params[:id])

    if project.user == @current_user
      project.destroy
      render json: :ok
    else
      render json: t("user.errors.not_permitted"), status: :unauthorized
    end
  end

  private

  def project_params
    params.require(:data).permit(:name)
  end
end