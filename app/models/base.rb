class Base < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :type, presence: true
  enum type:[:"出勤", :"退勤"] # 拠点種類
end
