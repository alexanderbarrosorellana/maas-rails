class ShiftSerializer < ActiveModel::Serializer
  attributes :id, :assigned, :start_time, :end_time, :date, :service_id

  belongs_to :engineer

  def start_time
    object.start_time.strftime('%H:%M %p')
  end

  def end_time
    object.end_time.strftime('%H:%M %p')
  end
end
