class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    if login(email, password)
      flash[:success] = 'ログインに成功しました。'
      redirect_to @user
      return
    end
    
    flash.now[:danger] = 'ログインに失敗しました。'
    render 'new'
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'ログアウトしました。'
    redirect_to root_path
  end
  
  private

  def login(email, password)
    @user = User.find_by(email: email)
    if @user != @user.authenticate(password)
      return false
    end
    
    session[:user_id] = @user.id
    return true
  end
end
