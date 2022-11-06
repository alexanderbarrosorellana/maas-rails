class Shift < ApplicationRecord
  belongs_to :service
  belongs_to :engineer, optional: true
  has_many :engineer_shifts

  scope :by_week, ->(date) { where(date: date.beginning_of_week..date.end_of_week) }
  scope :by_service, ->(service_id) { where(service_id: service_id) }

end
