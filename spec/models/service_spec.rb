# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Service, type: :model do
  it_behaves_like 'allocator'

  it { is_expected.to have_many(:engineers) }
  it { is_expected.to have_many(:shifts) }

  describe 'Validations' do
    before(:each) { @service = FactoryBot.build(:service) }

    context 'with valid attributes' do
      it 'is valid with specified name' do
        expect(@service).to be_valid
      end
    end

    context 'with invalid attributes' do
      before(:each) { @service = FactoryBot.build(:service, name: nil) }

      it 'is invalid without name' do
        expect(@service).to_not be_valid
      end
    end
  end
end
