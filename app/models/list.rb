# frozen_string_literal: true

class List < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_many :items, dependent: :destroy
end
