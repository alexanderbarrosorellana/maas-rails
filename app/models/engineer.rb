class Engineer < ApplicationRecord
  belongs_to :service
  has_many :engineer_shifts
end
