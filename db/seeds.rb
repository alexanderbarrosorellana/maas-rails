# frozen_string_literal: true

require 'faker'

p '###############################'
p 'Initializing database seeding'
p '###############################'

p 'Cleaning database...'
EngineerShift.destroy_all
Shift.destroy_all
Engineer.destroy_all
Service.destroy_all

p 'Creating Services'
3.times do |i|
  Service.create(name: "#{Faker::Company.name}#{i}")
end

# [{week: [initial_hour, total_hours], weekend: [initial_hour, total_hours]}]
@shifts_definitions = [
  {
    week: ['19:00:00 +0000', 5],
    weekend: ['12:00:00 +0000', 10]
  },
  {
    week: ['08:00:00 +0000', 5],
    weekend: ['08:00:00 +0000', 10]
  },
  {
    week: ['13:00:00 +0000', 6],
    weekend: ['13:00:00 +0000', 10]
  }
]

def weekend?(wday)
  wday == 6 || wday.zero?
end

def create_shift_list(initial_time, total_hours)
  hours_to_add = 0
  Array.new(total_hours).map.with_index do |_h, idx|
    hours_to_add += 1
    { start_time: initial_time + idx.hours, end_time: (initial_time + hours_to_add.hours) }
  end
end

@today = Date.today
# starting from monday on the 1st week and sunday on the 5th week
@starting_week_day = @today.beginning_of_week
@ending_week_day = (@today + 4.weeks).end_of_week

def create_weekend_shifts(weekend_starting_hour, weekend_total_hours, service_id, date)
  weekend_shift_list = create_shift_list(weekend_starting_hour, weekend_total_hours)

  weekend_shift_list.map do |shift|
    shift.merge({ service_id: service_id, date: date })
  end
end

def create_week_shifts(week_starting_hour, week_total_hours, service_id, date)
  week_shift_list = create_shift_list(week_starting_hour, week_total_hours)
  week_shift_list.map do |shift|
    shift.merge({ service_id: service_id, date: date })
  end
end

def create_shifts(service_id)
  @shifts_definitions.each do |shift_definition|
    (@starting_week_day..@ending_week_day).each do |day|
      shift_list = []

      shift_list = if weekend?(day.wday)
                     create_weekend_shifts(
                       Time.parse(shift_definition[:weekend][0]),
                       shift_definition[:weekend][1],
                       service_id,
                       day
                     )
                   else
                     create_week_shifts(
                       Time.parse(shift_definition[:week][0]),
                       shift_definition[:week][1],
                       service_id,
                       day
                     )
                   end

      Shift.import(shift_list)
    end
  end
end

def create_engineers(service_id)
  engineer_list = Array.new(3).map.with_index do |_item, idx|
    { name: "#{Faker::JapaneseMedia::FmaBrotherhood.character} #{idx}", service_id: service_id }
  end

  Engineer.import(engineer_list)
end

def create_engineer_shifts(service_id, engineers)
  engineer_shifts = []
  engineers.each do |engineer|
    Service.includes(:shifts).find(service_id).shifts.first(25).pluck(:id).each do |shift_id|
      engineer_shifts << { engineer_id: engineer.id, shift_id: shift_id }
    end
  end

  EngineerShift.import(engineer_shifts)
end

Service.all.each do |service|
  print "\n"
  p "In Service #{service.name}, id: #{service.id}"
  p 'Creating Shifts'
  create_shifts(service.id)

  p 'Creating Egnineers'
  create_engineers(service.id)

  p 'Creating EngineerShifts'
  create_engineer_shifts(service.id, service.engineers)
  print "\n"
end

p 'Seeding successfull!'
p '###############################'
