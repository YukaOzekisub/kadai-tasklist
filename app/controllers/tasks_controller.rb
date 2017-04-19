class TasksController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @tasks = Task.all
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def new
    @task = Task.new
    @form_type = 'new'
  end
  
  def edit
    @task = Task.find(params[:id])
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
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to @task
      return
    end
    
    flash.now[:danger] = 'Taskは更新されませんでした'
    render :edit
  end
  
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to tasks_url
  end
  
  
  private
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
end
