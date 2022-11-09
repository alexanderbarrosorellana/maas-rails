# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shift, type: :model do
  it { is_expected.to belong_to(:service) }
  it { is_expected.to belong_to(:engineer).optional }
  it { is_expected.to have_many(:engineer_shifts) }

  describe 'scopes' do
    context '#by_week' do
      before(:each) do
        @date = Date.today
        @shifts_by_week = FactoryBot.create_list(:shift, 5, date: @date)

        # create extra shifts outside @date
        FactoryBot.create_list(:shift, 3, date: @date + 3.weeks)
      end

      it 'returns shifts within the week by date given' do
        expect(Shift.by_week(@date)).to match_array(@shifts_by_week)
      end
    end

    context '#by_service' do
      before(:each) do
        @service = FactoryBot.create(:service)
        @date = Date.today
        @shifts_by_service = FactoryBot.create_list(:shift, 5, service: @service)

        # create extra shifts wiht other service
        FactoryBot.create_list(:shift, 3)
      end

      it 'returns all the shifts from service by service id given' do
        expect(Shift.by_service(@service.id)).to match_array(@shifts_by_service)
      end
    end
  end

  describe '#save' do
    before(:each) { @engineer = FactoryBot.create(:engineer) }

    context 'when updating engineer id from nil' do
      before(:each) { @shift = FactoryBot.build(:shift, engineer: nil) }

      it 'updates assign to true' do
        expect { @shift.update(engineer: @engineer) }
          .to change { @shift.assigned }.from(false).to(true)
      end
    end

    context 'when updating engineer id to nil' do
      before(:each) {  @shift = FactoryBot.create(:shift, engineer: @engineer) }

      it 'updates assign to true' do
        expect { @shift.update(engineer: nil) }
          .to change { @shift.assigned }.from(true).to(false)
      end
    end
  end
end
