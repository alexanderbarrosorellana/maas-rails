# frozen_string_literal: true

# Allocator Service
class AllocatorService
  attr_reader :assigned_shifts_counter, :assigned_shifts, :week_shift_hash, :total_week_hours, :engineers_size

  def initialize(week_shift_hash, total_week_hours, engineers_size)
    @assigned_shifts_counter = Hash.new(0)
    @assigned_shifts = []
    @week_shift_hash = week_shift_hash
    @total_week_hours = total_week_hours
    @engineers_size = engineers_size
  end

  def call
    allocate
  end

  def allocate # rubocop:disable all
    week_hours_limit = total_week_hours / engineers_size

    week_shift_hash.each do |(day, shift_hash)|
      # [{shift_id: [engineer_ids]}]
      engineer_total_shifts = count_engineer_total_shifts(week_shift_hash)

      # remove engineer without shifts and sort desc by shifts
      engineer_ids_filtered = engineer_total_shifts.select { |_id, shift_size| shift_size.positive? }
      engineer_ids = engineer_ids_filtered.sort_by(&:last).reverse!.map(&:first)

      engineer_ids.each do |engineer_id|
        average = average_engineers_shifts(engineer_ids, engineer_id, assigned_shifts_counter)
        limit_reached = assigned_shifts_counter[engineer_id] >= week_hours_limit

        next if limit_reached || assigned_shifts_counter[engineer_id] > average

        shifts_to_assign = shift_hash.select { |_k, ids| ids.include?(engineer_id) }.map(&:first)

        next if shifts_to_assign.empty?

        assign_shifts(shifts_to_assign, engineer_id, day)
      end
    end

    assigned_shifts
  end

  def count_engineer_total_shifts(week_shift_hash)
    engineer_total_shifts = Hash.new(0)
    week_shift_hash.each_value do |shift_values|
      shift_values.each_value do |engineer_ids|
        engineer_ids.each do |id|
          if engineer_total_shifts[id]
            engineer_total_shifts[id] += 1
          else
            engineer_total_shifts[id] = 1
          end
        end
      end
    end
    engineer_total_shifts
  end

  def average_engineers_shifts(engineer_ids, current_id, assigned_shifts_counter)
    rest_engineer_ids = engineer_ids.reject { |id| current_id == id }
    total_shifts = rest_engineer_ids.reduce(0) do |memo, id|
      assigned_to_engineer = assigned_shifts_counter[id] || 0
      memo + assigned_to_engineer
    end
    total_shifts / rest_engineer_ids.size
  end

  def assign_shifts(shifts_to_assign, engineer_id, day)
    current_assigned_shifts = []
    shifts_to_assign.each do |shift_to_assign|
      if assigned_shifts_counter[engineer_id]
        assigned_shifts_counter[engineer_id] += 1
      else
        assigned_shifts_counter[engineer_id] = 1
      end

      current_assigned_shifts << shift_to_assign
      assigned_shifts << { id: shift_to_assign, engineer_id: engineer_id }
    end
    # remove assigned shifts from week shift hash
    week_shift_hash[day].reject! { |k| current_assigned_shifts.include?(k) }
  end
end
