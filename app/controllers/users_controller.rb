class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]

  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @task = current_user.tasks.build  # form_for 用
    @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
      return
    end
    
    flash.now[:danger] = 'ユーザの登録に失敗しました。'
    render :new
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end
