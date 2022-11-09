# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllocatorService, type: :model do
  before(:each) do
    @week_shift_hash = { Date.today => { 1 => [5, 7], 3 => [5, 7] } }
    @engineer_size = 2
    @total_week_hours = 2
    @allocator_service = AllocatorService.new(@week_shift_hash, @total_week_hours, @engineer_size)
  end

  describe '#call' do
    it 'calls to allocate' do
      expect(@allocator_service).to receive(:allocate)
      @allocator_service.call
    end
  end

  describe '#allocate' do
    it 'allocate engineers to shifts' do
      expected_array = [{ id: 1, engineer_id: 7 }, { id: 3, engineer_id: 7 }]
      expect(@allocator_service.allocate).to match_array(expected_array)
    end
  end

  describe '#count_engineer_total_shifts' do
    it 'returns a hash with engineer id as key and total shifts as value' do
      expected_hash = { 5 => 2, 7 => 2 }
      engineer_shift_size = @allocator_service.count_engineer_total_shifts(@week_shift_hash)
      expect(engineer_shift_size).to eq(expected_hash)
    end
  end

  describe '#average_engineers_shifts' do
    it 'returns the average from other engineer shifts' do
      average = @allocator_service.average_engineers_shifts([7, 5], 5, { 7 => 2 })
      expect(average).to be(2)
    end
  end

  describe '#assign_shifts' do
    it 'assign shifts to engineer' do
      @allocator_service.assign_shifts([1, 3], 5, Date.today)
      expected_array = [{ id: 1, engineer_id: 5 }, { id: 3, engineer_id: 5 }]
      expect(@allocator_service.assigned_shifts).to match_array(expected_array)
    end

    it 'removes assigned shifts from week hash' do
      @allocator_service.assign_shifts([1, 3], 5, Date.today)
      expected_hash = { Date.today => {} }
      expect(@allocator_service.week_shift_hash).to eq(expected_hash)
    end
  end
end
