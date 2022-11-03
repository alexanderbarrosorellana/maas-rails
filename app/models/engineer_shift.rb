class EngineerShift < ApplicationRecord
  belongs_to :engineer, optional: true
  belongs_to :shift
end
