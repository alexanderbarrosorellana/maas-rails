# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Services', type: :request do
  describe 'GET /index' do
    before(:each) do
      @services = FactoryBot.create_list(:service, 3)
    end

    it 'returns all services' do
      get api_v1_services_path
      expect(response).to have_http_status(200)
      response_body_names = JSON.parse(response.body).pluck('name')
      expect(response_body_names).to match_array(Service.all.pluck(:name))
    end
  end

  describe 'GET /show/:id/:date' do
    before(:each) do
      @services = FactoryBot.create_list(:service, 3)

      @services.each do |s|
        FactoryBot.create(:shift, service: s)
      end
    end

    it 'returns current service with shifts from date' do
      service = @services.sample
      date_shift = service.shifts.first.date
      get "#{api_v1_services_path}/#{service.id}", params: { date: date_shift }

      expect(response).to have_http_status(200)
      response_service_id = JSON.parse(response.body)['id']
      expect(response_service_id.to_i).to be(service.id)
    end
  end
end
