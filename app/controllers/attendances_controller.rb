class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_approving_one_month, :update_approving_one_month, :edit_applying_change, :update_applying_change, :edit_approving_overtime, :update_approving_overtime, :edit_approving_change, :update_approving_change]
  before_action :logged_in_user, only: [:update, :edit_applying_change]
  before_action :set_one_month, only: [:edit_applying_change, :update_applying_change]
  before_action :admin_or_correct_user, only: [:update, :edit_applying_change, :update_applying_change]
  before_action :set_users_need_one_month_approvals, only: [:edit_approving_one_month, :update_approving_one_month]
  before_action :set_users_need_change_approvals, only: [:edit_approving_change, :update_approving_change]
  before_action :set_users_need_overtime_approvals, only: [:edit_approving_overtime, :update_approving_overtime]
  before_action :set_attendances_need_one_month_approvals, only: [:edit_approving_one_month, :update_approving_one_month]
  before_action :set_attendances_need_change_approvals, only: [:edit_approving_change, :update_approving_change]
  before_action :set_attendances_need_overtime_approvals, only: [:edit_approving_overtime, :update_approving_overtime]

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    time = Time.current.change(sec: 0)
    if @attendance.started_at.nil? # 出勤時間が未登録であることを判定します。
      if @attendance.update_attributes(started_at: time, started_at_original: time, started_at_applying: time)
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: time, finished_at_original: time, finished_at_applying: time)
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  
  # 勤怠1か月分承認申請処理
  def update_one_month
#    debugger
    @user = User.find_by(id: params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.update_attributes(approver_one_month: params[:approver_one_month])
      @attendance.update_attributes(status_one_month: "applying_one_month")
      flash[:info] = "#{@attendance.worked_on.month}月分の承認依頼を#{@attendance.approver_one_month}に申請しました。"
    else
      flash[:danger] = "申請エラー。#{@attendance.worked_on.month}月分の承認依頼に失敗しました。承認先を正しく選んでください。"
    end
#    debugger
    redirect_to user_url(id: params[:user_id])
  end
  
  # 勤怠1か月分承認承認ページ
  def edit_approving_one_month
  end
  
  # 勤怠1か月分承認処理
  def update_approving_one_month
  end
  
  
  # 勤怠変更申請ページ
  def edit_applying_change
    @attendance = Attendance.find_by(user_id: params[:id]) # viewでNoMethodエラーが出ないように入れているだけ。
#    @users_superior = User.where(superior: true).where.not(id: params[:id])
  end
  
  # 勤怠変更申請処理
  def update_applying_change
    #debugger
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        unless item[:"approver"] == "" # 上司を選ばないと申請できない。
          attendance = Attendance.find(id)
#debugger
          # started_atに入力があった場合に、started_atを整え、初めての入力であればoriginalにその値を代入する。
          if item[:"started_at"]
            item[:"started_at"] = attendance.worked_on.to_s + " " + item[:"started_at"] + ":00"
            item[:"started_at_original"] = item[:"started_at"] unless attendance.started_at_original
          end
          # finished_atに入力があった場合に、finished_atを整え、初めての入力であればoriginalにその値を代入する。
          if item[:"finished_at"]
            finish_day = attendance.worked_on
            finish_day += 1.day if params[:next_day][id] == "1"
            item[:"finished_at"] = finish_day.to_s + " " + item[:"finished_at"] + ":00"
            item[:"finished_at_original"] = item[:"finished_at"] unless attendance.finished_at_original
          end
          # applyingに申請値を代入
          item[:"started_at_applying"] = item[:"started_at"]
          item[:"finished_at_applying"] = item[:"finished_at"]
          # 現状（申請前）の値を保存
          item[:"started_at"] = attendance.started_at
          item[:"finished_at"] = attendance.finished_at
          # 更新及び申請
          item[:"status"] = "applying"
#debugger
          attendance.update_attributes!(item)
        end
      end
    end
    flash[:success] = "勤怠変更申請を上呈しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
    redirect_to attendances_edit_applying_change_user_url(date: params[:date])
  end
  
  # 勤怠変更承認ページ
  def edit_approving_change
  end
  
  # 勤怠変更承認処理
  def update_approving_change
    #debugger
    approve_change_params.each do |id, item|
      if params[:approve_change][:"#{id}"] == "1"
        attendance = Attendance.find(id)
        if item[:"status"] == "approved"
          # applyingの申請値を実際の勤怠情報に反映
          item[:"started_at"] = attendance.started_at_applying
          item[:"finished_at"] = attendance.finished_at_applying
          item[:"approved_on"] = Time.current.change(sec: 0)
        end
        attendance.update_attributes(item)
      end
    end
    flash[:info] = "勤怠変更申請者に承認結果を送付しました。"
    redirect_to user_url(date: params[:date])
  end
  
  # 残業申請ページ
  def edit_overtime
    @user = User.find_by(id: params[:user_id])
    @users_superior = User.where(superior: true).where.not(id: params[:user_id])
    @attendance = Attendance.find_by(user_id: params[:user_id], id: params[:id])
    # その日の定時をセット
    date = @attendance.worked_on
    time = @user.designated_work_end_time
    @attendance.regular_end_time = DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec, 0.375); p @attendance.regular_end_time
    @attendance.save
#    debugger
  end
  
  # 残業申請処理
  def update_overtime
    #debugger
    @user = User.find_by(id: params[:user_id])
    @attendance = Attendance.find(params[:id])
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
    redirect_to user_url(id: params[:user_id])
  end
  
  # 残業承認ページ
  def edit_approving_overtime
  end
  
  # 残業承認処理
  def update_approving_overtime
    #debugger
    approve_overtime_params.each do |id, item|
      if params[:approve_overtime][:"#{id}"] == "1"
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      end
    end
    flash[:info] = "残業申請者に承認結果を送付しました。"
    redirect_to user_url(date: params[:date])
  end
  
  private
    # Userに紐づいた複数の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at,
                                                :finished_at,
                                                :note,
                                                :status,
                                                :approver,
                                                :started_at_original,
                                                :finished_at_original,
                                                :started_at_applying,
                                                :finished_at_applying])[:attendances]
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
    
    # 1ヵ月残業時間の勤怠情報を扱います。
    def approve_one_month_params
      params.require(:attendance).permit(attendances_need_one_month_approvals: [:status_one_month, :approver_one_month])[:attendances_need_one_month_approvals]
    end
    
    # 勤怠変更上呈承認情報を扱います。
    def approve_change_params
      params.require(:attendance).permit(attendances_need_change_approvals: [:status,
                                                                            :started_at,
                                                                            :finished_at])[:attendances_need_change_approvals]
    end
    
    # 残業時間の勤怠情報を扱います。
    def approve_overtime_params
      params.require(:attendance).permit(attendances_need_overtime_approvals: [:overtime_finish_at,
                                                                              :overtime_status,
                                                                              :overtime_approver,
                                                                              :overtime_note])[:attendances_need_overtime_approvals]
    end
    
end
