class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, except: [:new, :create, :show]
#  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_or_correct_user, only: [:edit, :update]
  before_action :set_one_month, only: :show
  before_action :set_attendances_need_approvals, only: :show
  
  def index
    @users = User.paginate(page: params[:page], per_page: 20).search(params[:searchword])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功後、ログインします。
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    
    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string, filename: "attendances.csv", type: :csv
      end
    end
#    debugger
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
  
  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def import
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    flash[:success] = "#{:file}をインポートしました。"
    redirect_to users_url
  end

  def index_members_during_work
    @users_during_work=[]
    users = User.all
    users.each do |user|
      attendance_status = user.attendances.find_by(worked_on: Date.current)
      if attendance_status && attendance_status.started_at
        @users_during_work << user unless attendance_status.finished_at
      end
    end
#    @users = @users.paginate(page: params[:page], per_page: 20)
  end
  

  private

    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :department,
                                   :employee_number,
                                   :uid,
                                   :password,
                                   :password_confirmation,
                                   :basic_time,
                                   :designated_work_start_time,
                                   :designated_work_end_time)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end
  
end
