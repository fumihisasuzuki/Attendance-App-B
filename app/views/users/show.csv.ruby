require 'csv'
bom = "\uFEFF" # BOM付にすることで、Excelで開いた際の文字化けを回避。4行目の(bom)も同様

CSV.generate(bom) do |csv|
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
        nil,
        attendance.note
      ]
    else
      column_values = [
        attendance.worked_on,
        nil,
        nil,
        nil,
        nil,
        attendance.note
      ]
    end
    csv << column_values
  end
end