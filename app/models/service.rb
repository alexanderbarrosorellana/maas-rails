# frozen_string_literal: true

# Class to represent service
class Service < ApplicationRecord
  include Allocator

  has_many :engineers
  has_many :shifts

  validates :name, presence: true
end
