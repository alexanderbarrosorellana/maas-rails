# frozen_string_literal: true

# Concern to allocate engineers to shifts
module Allocator
  extend ActiveSupport::Concern

  included do
    def assign_week_shifts(date)
      engineers_size = engineers.size
      return if engineers_size.zero?

      week_shifts = shifts.by_week(date)

      run_sanity_check(week_shifts)

      # week_shift_hash {day: { shift_id: [engineer_ids]}}
      week_shift_hash = create_week_shift_hash(week_shifts)

      allocations = AllocatorService.new(week_shift_hash, week_shifts.size, engineers_size).call
      allocations.map { |allocation| allocation.merge!({ assigned: true, service_id: id }) }

      Shift.upsert_all(allocations, update_only: %i[engineer_id assigned])
    end
  end

  def create_week_shift_hash(week_shifts) # rubocop:disable Metrics/AbcSize
    week_shift_hash = {}
    week_shifts.includes(:engineer_shifts).each do |shift|
      engineer_shifts = shift.engineer_shifts
      next if engineer_shifts.size.zero?

      shift_id = shift.id

      engineer_ids = engineer_shifts.pluck(:engineer_id)

      if week_shift_hash[shift.date] # rubocop:disable Style/ConditionalAssignment
        week_shift_hash[shift.date] = week_shift_hash[shift.date].merge({ shift_id => engineer_ids })
      else
        week_shift_hash[shift.date] = { shift_id => engineer_ids }
      end
    end
    week_shift_hash
  end

  def run_sanity_check(week_shifts)
    shifts_to_update = []
    week_shifts.includes(:engineer_shifts).where.not(engineer_id: nil).each do |shift|
      shifts_to_update << shift.id unless shift.engineer_shift_ids.include?(shift.engineer_id)
    end
    Shift.where(id: shifts_to_update).update_all(engineer_id: nil, assigned: false)
  end
end
