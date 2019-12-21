require 'csv'

CSV.generate do |csv|
  column_names = %w(day started_hour started_minute finished_hour finished_minute note)
  csv << column_names
  @attendances.each do |attendance|
    if attendance.finished_at
      column_values = [
        attendance.worked_on,
        l(attendance.started_at, format: :hour),
        l(attendance.started_at, format: :minute),
        l(attendance.finished_at, format: :hour),
        l(attendance.finished_at, format: :minute),
        attendance.note
      ]
    elsif attendance.started_at
      column_values = [
        attendance.worked_on,
        l(attendance.started_at, format: :hour),
        l(attendance.started_at, format: :minute),
        nil,
        attendance.note
      ]
    else
      column_values = [
        attendance.worked_on,
        nil,
        nil,
        attendance.note
      ]
    end
    csv << column_values
  end
end