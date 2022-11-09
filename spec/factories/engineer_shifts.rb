# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :engineer_shift do
    engineer
    shift
  end
end
