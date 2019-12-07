class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy]
  before_action :admin_or_correct_user, only: [:show, :edit, :update]
  
  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end
  
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
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = @user.name + 'のアカウント情報更新に成功しました。'
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = @user.name + 'を削除しました。'
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    # beforeフィルター

    # 現在のユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end
    
    # ログイン済みのユーザーか確認 :sessons_helperに記載
    
    # アクセスしたユーザーが現在ログインしているユーザー本人か確認します。
    def correct_user
      unless current_user?(@user)
        flash[:danger] = "他人のユーザー情報は編集・更新できません。"
        redirect_to(root_url)
      end
    end
    
    # 現在ログインしているユーザーが管理者権限を持っているか確認します。
    def admin_user
      unless current_user.admin?
        flash[:danger] = "アクセスするためには管理者権限が必要です。"
        redirect_to(root_url)
      end
    end
    
    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "アクセスするためには本人のログインまたは管理者権限が必要です。"
        redirect_to(root_url)
      end  
    end
    
end
