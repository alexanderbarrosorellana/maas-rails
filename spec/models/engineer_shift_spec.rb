# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EngineerShift, type: :model do
  it { is_expected.to belong_to(:engineer).optional }
  it { is_expected.to belong_to(:shift) }
end
