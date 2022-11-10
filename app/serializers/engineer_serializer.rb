class EngineerSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :engineer_shifts
end
