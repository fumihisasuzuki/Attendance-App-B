class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :edit_approving_overtime]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :set_one_month, only: :edit_one_month
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
    @attendance = Attendance.find_by(user_id: params[:id]) # viewでNoMethodエラーが出ないように入れているだけ。
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
#    errors.presence || nil
#    flash[:danger] = @attendance.errors.presence.to_s || nil
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def edit_overtime
    @user = User.find_by(id: params[:user_id])
    @users_superior = User.where(superior: true)
    @attendance = Attendance.find_by(user_id: params[:user_id], id: params[:id])
  end
  
  def update_overtime
    @user = User.find_by(id: params[:user_id])
    @attendance = Attendance.find(params[:id])
    @attendance.update_attributes(attendance_params)
    @attendance.update_attributes(overtime_status: 1)
    # flash[:success] = '残業を申請しました。'
    flash[:info] = "#{@attendance.worked_on}の残業を#{@attendance.overtime_approver}に申請しました。"
    redirect_to user_url(id: params[:user_id])
  end
  
  def edit_approving_overtime
    # 名前で検索！？同性同名の人がいるかもしれないし、idの方が良いね。
    @attendances = Attendance.where(overtime_approver: @user.name)
    # @userに残業申請を上呈しているユーザーの一覧
    @users_need_approvals = []
    users = User.all
    users.each do |user|
      @users_need_approvals << user if user.attendances.find_by(overtime_approver: @user.name)
    end
  end
  
  def update_approving_overtime
  end
  
  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
    
    # その日の勤怠情報を扱います。
    def attendance_params
      params.require(:attendance).permit(:started_at,
                                         :finished_at,
                                         :note,
                                         :status,
                                         :approver,
                                         :status_one_month,
                                         :approver_one_month,
                                         :overtime_finish_at,
                                         :overtime_status,
                                         :overtime_approver,
                                         :overtime_note)
    end
end
