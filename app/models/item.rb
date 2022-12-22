# frozen_string_literal: true

class Item < ApplicationRecord
  acts_as_paranoid

  belongs_to :list
end
