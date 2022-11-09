# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :shift do
    time_now = Time.parse(Time.now.strftime('%H:00:00 +0000'))
    assigned { false }
    start_time { time_now }
    end_time { time_now + 1.hour }
    date { Date.today }
    engineer { nil }
    service
  end
end
