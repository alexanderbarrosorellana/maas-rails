module Api
  module V1
    class EngineerShiftsController < ApplicationController
      def create
        @engineer_shift = EngineerShift.new(engineer_shift_params)
        if @engineer_shift.save
          render json: @engineer_shift, status: :created
        else
          render json: { message: @engineer_shift.errors.full_messages }, status: 422
        end
      end

      def destroy
        @engineer_shift = EngineerShift.find(params.fetch(:id, nil).to_i)
        if @engineer_shift
          @engineer_shift.destroy

          if @engineer_shift.destroyed?
            render json: { message: 'Destroyed' }, status: :ok
          else
            render json: { message: @engineer_shift.errors.full_messages }, status: 422
          end
        else
          render json: { message: 'Record not found' }, status: 404
        end
      end

      private

      def engineer_shift_params
        params.require(:engineer_shift).permit(:shift_id, :engineer_id)
      end
    end
  end
end
