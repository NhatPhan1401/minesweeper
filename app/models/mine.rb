class Mine < ApplicationRecord
  belongs_to :board

  validates :x, :y, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
