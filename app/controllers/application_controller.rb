class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  
  # beforeフィルター

  # 現在のユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end
    
  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

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
    @user = params[:user_id].nil? ? User.find(params[:id]) : User.find(params[:user_id])
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "アクセスするためには本人のログインまたは管理者権限が必要です。"
      redirect_to(root_url)
    end
  end

  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価。
      ActiveRecord::Base.transaction do # トランザクションを開始。繰り返し処理により、1ヶ月分の勤怠データを生成。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
  
  # @userに1ヵ月分の承認申請を上呈しているユーザーの一覧
  def set_users_need_one_month_approvals
    @users_need_one_month_approvals = []
    users = User.all
    users.each do |user|
      # 名前で検索！？同性同名の人がいるかもしれないし、idの方が良いね。要修正。
      if user.attendances.find_by(approver_one_month: @user.name, status_one_month: 1)
        @users_need_one_month_approvals << user
      end
    end
  end
  
  # @userに勤怠変更申請を上呈しているユーザーの一覧
  def set_users_need_change_approvals
    @users_need_change_approvals = []
    users = User.all
    users.each do |user|
      # 名前で検索！？同性同名の人がいるかもしれないし、idの方が良いね。要修正。
      if user.attendances.find_by(approver: @user.name, status: 1)
        @users_need_change_approvals << user
      end
    end
  end
  
  # @userに残業申請を上呈しているユーザーの一覧
  def set_users_need_overtime_approvals
    @users_need_overtime_approvals = []
    users = User.all
    users.each do |user|
      # 名前で検索！？同性同名の人がいるかもしれないし、idの方が良いね。要修正。
      if user.attendances.find_by(overtime_approver: @user.name, overtime_status: 1)
        @users_need_overtime_approvals << user
      end
    end
  end
    
  # @userに1ヵ月分の承認申請を上呈している勤怠情報一覧
  def set_attendances_need_one_month_approvals
    @attendances_need_one_month_approvals = Attendance.includes(:user).references(:user).where(approver_one_month: @user.name).where(status_one_month: 1)
    #debugger
  end
  
  # @userに勤怠変更申請を上呈している勤怠情報一覧
  def set_attendances_need_change_approvals
    @attendances_need_change_approvals = Attendance.includes(:user).references(:user).where(approver: @user.name).where(status: 1)
    #debugger
  end
  
  # @userに残業申請を上呈している勤怠情報一覧
  def set_attendances_need_overtime_approvals
    @attendances_need_overtime_approvals = Attendance.includes(:user).references(:user).where(overtime_approver: @user.name).where(overtime_status: 1)
    #debugger
  end
  
end
