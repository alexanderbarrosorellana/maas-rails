class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :engineers
  has_many :shifts

  def shifts
    object_shifts = object.shifts.includes(:engineer_shifts)
    if @instance_options[:parsed_date]
      parsed_date = @instance_options[:parsed_date]
      object_shifts = object_shifts.by_week(parsed_date)
    end

    shifts_with_engineer_shifts = []
    object_shifts.order(:date).order(:start_time).each do |shift|
      shifts_with_engineer_shifts << shift.attributes.merge!({ engineer_shifts: shift.engineer_shifts })
    end
    shifts_with_engineer_shifts
  end

  def engineers
    engineers_with_engineer_shits = []
    object_engineers = object.engineers.includes(:engineer_shifts)

    object_engineers.each do |engineer|
      engineers_with_engineer_shits << engineer.attributes.merge!({ engineer_shifts: engineer.engineer_shifts })
    end
    engineers_with_engineer_shits
  end
end
