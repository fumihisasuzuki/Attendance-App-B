class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :edit_approving_overtime, :update_approving_overtime]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :set_one_month, only: :edit_one_month
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_users_need_approvals, only: [:edit_approving_overtime, :update_approving_overtime]
  before_action :set_attendances_need_approvals, only: [:edit_approving_overtime, :update_approving_overtime]

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
        if item[:"started_at"]
          item[:"started_at"] = attendance.worked_on.to_s + " " + item[:"started_at"] + ":00"
#debugger
          finish_day = attendance.worked_on
          finish_day += 1.day if params[:next_day][id] == "1"
          item[:"finished_at"] = finish_day.to_s + " " + item[:"finished_at"] + ":00"
#debugger
          attendance.update_attributes!(item)
#debugger
        end
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
#debugger
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
#    errors.presence || nil
#    flash[:danger] = @attendance.errors.presence.to_s || nil
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def edit_overtime
    @user = User.find_by(id: params[:user_id])
    @users_superior = User.where(superior: true).where.not(id: params[:user_id])
    @attendance = Attendance.find_by(user_id: params[:user_id], id: params[:id])
    date = @attendance.worked_on
    time = @user.designated_work_end_time
    @attendance.regular_end_time = DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec, 0.375); p @attendance.regular_end_time
    @attendance.save
#    debugger
  end
  
  def update_overtime
#    debugger
    @user = User.find_by(id: params[:user_id])
    @attendance = Attendance.find(params[:id])
#    debugger
    if params[:attendance][:overtime_finish_at] == ""
      flash[:danger] = "申請エラー。残業時間は必須項目です。"
    else
      finish_day = @attendance.worked_on
      finish_day += 1.day if params[:attendance][:next_day] == "1"
      params[:attendance][:overtime_finish_at] = finish_day.to_s + " " + params[:attendance][:overtime_finish_at] + ":00"
      if params[:attendance][:overtime_note] == ""
        flash[:danger] = "申請エラー。業務処理内容は必須項目です。"
      else
        params[:attendance][:overtime_status] = "applying_overtime"
        if @attendance.update_attributes(attendance_params)
          flash[:info] = "#{@attendance.worked_on}の残業を#{@attendance.overtime_approver}に申請しました。"
        else
          flash[:danger] = "申請エラー。残業時間は、出勤時間より後にしてください。日をまたぐ場合は、翌日にチェックを入れて下さい。"
        end
      end
    end

#    debugger
#    unless @attendance.update_attributes(overtime_status: 1)
#      flash[:danger] = "上呈に失敗しました。システムにお問い合わせ下さい。" + @attendance.errors.full_messages.join("<br>")
#      redirect_to user_url(date: params[:date]) and return
#    end
#    debugger
#    if params[:attendance][:next_day] == "1"
#      unless @attendance.update_attributes(overtime_finish_at: @attendance.overtime_finish_at + 1.day)
#        flash[:danger] = "翌日処理に失敗しました。システムにお問い合わせ下さい。" + @attendance.errors.full_messages.join("<br>")
#        redirect_to edit_overtime_user_attendance_url(@user, @attendance) and return
#      end
#    end
#    debugger
    redirect_to user_url(id: params[:user_id])
  end
  
  def edit_approving_overtime
  end
  
  def update_approving_overtime
    approve_overtime_params.each do |id, item|
#      debugger
      if params[:approve_overtime][:"#{id}"] == "1"
#      debugger
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
#      debugger
      end
    end
    flash[:info] = "残業申請者に承認結果を送付しました。"
    redirect_to user_url(date: params[:date])
  end
  
  private
    # Userに紐づいた複数の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :overtime_status])[:attendances]
    end
    
    # 残業時間の勤怠情報を扱います。
    def approve_overtime_params
      params.require(:attendance).permit(attendances_need_approvals: [:overtime_finish_at,
                                                                      :overtime_status,
                                                                      :overtime_approver,
                                                                      :overtime_note])[:attendances_need_approvals]
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
