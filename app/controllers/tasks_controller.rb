class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :can_not_edit_else_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = Task.all
  end
  
  def show
    
  end
  
  def new
    @task = Task.new
    @form_type = 'new'
  end
  
  def edit
    @form_type = 'edit'
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'Taskが正常に作成されました'
      redirect_to @task
      return
    end
    flash.now[:danger] = 'Taskが作成されませんでした'
    render :new
  end 
  
  def update
    
    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to @task
      return
    end
    
    flash.now[:danger] = 'Taskは更新されませんでした'
    render :edit
  end
  
  
  def destroy
    @task.destroy
    
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to user_url(id: session[:user_id])
  end
  
  
  private
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  
  def can_not_edit_else_user
    @task = Task.find_by(id: params[:id])
    render 'page_error' and return if @task.nil?
    return if current_user.id.to_i == @task.user.id.to_i
    render 'page_error'
  end
end
