# frozen_string_literal: true

class List < ApplicationRecord
  acts_as_paranoid

  has_many :items
end
