# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'allocator' do
  let(:service) do
    FactoryBot.create(described_class.to_s.underscore)
  end

  describe '#assign_week_shifts' do
    before(:each) do
      start_time = Time.parse('08:00:00 +0000')
      added_hours = 0
      @shift_list = FactoryBot.build_list(:shift, 5).each_with_index do |shift, idx|
        added_hours += 1
        shift.update(
          start_time: start_time + idx.hours,
          end_time: start_time + added_hours.hours,
          service: service
        )
      end

      @engineers = FactoryBot.create_list(:engineer, 2, service: service)

      @engineers.each do |engineer|
        @shift_list.each do |shift|
          FactoryBot.create(:engineer_shift, engineer: engineer, shift: shift)
        end
      end
    end

    it 'assign shifts to engineers' do
      expected_array = Array.new(@shift_list.size).fill(true)
      service.assign_week_shifts(Date.today)
      expect(service.shifts.pluck(:assigned)).to match_array(expected_array)
    end
  end
end
