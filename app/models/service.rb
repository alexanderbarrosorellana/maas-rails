class Service < ApplicationRecord
  has_many :engineers
  has_many :shifts
end
