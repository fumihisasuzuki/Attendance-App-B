class Attendance < ApplicationRecord
  belongs_to :user
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  enum status:[:non, :applying, :approved, :not_approved] # 変更申請ステータス
  enum status_one_month:[:non_one_month, :applying_one_month, :approved_one_month, :not_approved_one_month] # 一か月分の申請ステータス
  enum overtime_status:[:non_overtime, :applying_overtime, :approved_overtime, :not_approved_overtime] # 残業申請のステータス
  
  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 過去の日付を編集する時、退勤時間が存在しない場合の出勤時間は無効
  validate :started_at_is_invalid_without_a_finished_at_at_past
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid
  # 過去の日付を編集する時、出勤時間が存在しない場合、残業時間は無効
#  validate :overtime_finish_at_is_invalid_without_a_started_at
  # 出勤・残業時間どちらも存在する時、出勤時間より早い残業時間は無効
#  validate :started_at_than_overtime_finish_at_fast_if_invalid

  # 出勤時間が存在しない場合、退勤時間は無効
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  # 過去の日付を編集する時、退勤時間が存在しない場合の出勤時間は無効
  def started_at_is_invalid_without_a_finished_at_at_past
    if self.worked_on < Date.current
      errors.add(:finished_at, "が必要です") if started_at.present? && finished_at.blank?
    end
  end
  
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
  
  # 過去の日付を編集する時、出勤時間が存在しない場合、残業時間は無効
#  def overtime_finish_at_is_invalid_without_a_started_at
#    errors.add(:started_at, "が必要です") if started_at.blank? && overtime_finish_at.present?
#  end
  
  # 出勤・残業時間どちらも存在する時、出勤時間より早い残業時間は無効
  def started_at_than_overtime_finish_at_fast_if_invalid
    if started_at.present? && overtime_finish_at.present?
      errors.add(:started_at, "より早い残業時間は無効です") if started_at > overtime_finish_at
    end
  end

end
