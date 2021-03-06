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
  def working_overtimes(regulartime_value, overtime_value)
#    format("%.2f", (((overtime.floor_to(time_unit.minutes) - designatedtime.floor_to(time_unit.minutes)) / 60 ) / 60.0))
#    debugger
#    format("%.2f", (((Tod::TimeOfDay(overtime.floor_to(time_unit.minutes)) - Tod::TimeOfDay(designatedtime.floor_to(time_unit.minutes))) / 60 ) / 60.0))
    regulartime = Tod::TimeOfDay(regulartime_value.floor_to(time_unit.minutes))
    overtime = Tod::TimeOfDay(overtime_value.floor_to(time_unit.minutes))
    differnce_hours = Tod::Shift.new(regulartime, overtime).duration/3600.00
    if regulartime_value > overtime_value
      format("%.2f",differnce_hours - 24)
    else
      format("%.2f",differnce_hours)
    end
#    debugger
  end
  
  # 出勤時間と退勤時間を受け取り、日をまたいでいるかどうか評価
  def overtime_next_day(start_day, finish_day)
    if start_day && finish_day
      if start_day.day == finish_day.day
        false
      else
        true
      end
    else
      false
    end
  end
 
end
