# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :engineer do
    name { Faker::JapaneseMedia::FmaBrotherhood.character }
    service
  end
end
