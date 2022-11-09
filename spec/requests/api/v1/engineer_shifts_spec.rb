require 'rails_helper'

RSpec.describe 'Api::V1::EngineerShifts', type: :request do
  describe 'POST ' do
    before(:each) do
      @service = FactoryBot.create(:service)
      @engineer = FactoryBot.create(:engineer, service: @service)
      @shift = FactoryBot.create(:shift, service: @service)
    end

    it 'creates a EngineerShift record' do
      params = { engineer_shift: { shift_id: @shift.id, engineer_id: @engineer.id } }
      post api_v1_engineer_shifts_path, params: params

      expect(response).to have_http_status(:created)
      expect(EngineerShift.count).to be(1)
    end
  end

  describe 'DELETE' do
    before(:each) { @engineer_shift = FactoryBot.create(:engineer_shift) }
    it 'destroys a EngineerShift record' do
      delete "#{api_v1_engineer_shifts_path}/#{@engineer_shift.id}"

      expect { @engineer_shift.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
