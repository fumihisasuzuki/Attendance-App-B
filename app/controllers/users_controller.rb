class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = @user.name + 'のユーザー情報の更新に成功しました。'
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = @user.name + 'を削除しました。'
    redirect_to users_path
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
end
