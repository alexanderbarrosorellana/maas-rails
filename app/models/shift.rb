class Shift < ApplicationRecord
  belongs_to :service
  belongs_to :engineer, optional: true
  has_many :engineer_shifts
end
