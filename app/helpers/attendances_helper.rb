module AttendancesHelper
  
  # 受け取ったAttendanceオブジェクトが当日と一致するか評価。
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  # 何分毎の表示に切り替えるかを返す
  def time_unit
    15
  end
  
  # 出勤時間と退勤時間を受け取り、在社時間を計算して返す
  def working_times(start, finish)
    format("%.2f", (((finish.floor_to(time_unit.minutes) - start.floor_to(time_unit.minutes)) / 60 ) / 60.0))
  end
  
  # 定時と残業予定時間を受け取り、時間外時間を計算して返す
  def working_overtimes(designatedtime, overtime)
#    format("%.2f", (((overtime.floor_to(time_unit.minutes) - designatedtime.floor_to(time_unit.minutes)) / 60 ) / 60.0))
#    debugger
#    format("%.2f", (((Tod::TimeOfDay(overtime.floor_to(time_unit.minutes)) - Tod::TimeOfDay(designatedtime.floor_to(time_unit.minutes))) / 60 ) / 60.0))
    format("%.2f",Tod::Shift.new(Tod::TimeOfDay(designatedtime.floor_to(time_unit.minutes)), Tod::TimeOfDay(overtime.floor_to(time_unit.minutes))).duration/3600.00)
#    debugger
  end
 
end
