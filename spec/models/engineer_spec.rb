# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Engineer, type: :model do
  it { is_expected.to belong_to(:service) }
  it { is_expected.to have_many(:engineer_shifts) }
end
