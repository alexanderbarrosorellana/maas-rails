# frozen_string_literal: true

module Api
  module V1
    # Controller for services
    class ServicesController < ApplicationController
      def index
        services = Service.all
        parsed_date = Date.parse(params[:date])
        render json: services, parsed_date: parsed_date
      end

      def show
        service = Service.find(params[:id])
        parsed_date = Date.parse(params[:date])

        service.assign_week_shifts(parsed_date)

        render json: service, include: ['shifts', 'shifts.engineer'], parsed_date: parsed_date
      end
    end
  end
end
