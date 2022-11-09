class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :engineers
  has_many :shifts

  def shifts
    object_shifts = object.shifts
    if @instance_options[:parsed_date]
      parsed_date = @instance_options[:parsed_date]
      object_shifts = object_shifts.by_week(parsed_date)
    end

    object_shifts.order(:date).order(:start_time)
  end
end
