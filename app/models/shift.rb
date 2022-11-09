# frozen_string_literal: true

# class to represent Shift, in this application shift represents 1 hour block
class Shift < ApplicationRecord
  belongs_to :service
  belongs_to :engineer, optional: true
  has_many :engineer_shifts

  scope :by_week, ->(date) { where(date: date.beginning_of_week..date.end_of_week) }
  scope :by_service, ->(service_id) { where(service_id: service_id) }

  before_save :check_assigned, if: :will_save_change_to_engineer_id?

  def check_assigned
    return self.assigned = true if engineer_id

    self.assigned = false
  end
end
