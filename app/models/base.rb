class Base < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
#  validates :place_type_status, presence: true
  enum place_type_status:[:in, :out] # 拠点種類
end
