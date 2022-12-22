# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    # sequence(:email) { |e| "first.last#{e}@email.com" }
    sequence(:email) { |n| "person#{n}@example.com" }
  end

  trait :with_lists_and_items do
    after(:create) do |user|
      lists = create_list(:list, 6, user: user)
      lists.each do |list|
        create_list(:item, 10, list: list)
      end
    end
  end

  trait :with_private_lists_and_items do
    after(:create) do |user|
      lists = create_list(:list, 7, is_public: false, user: user)
      lists.each do |list|
        create_list(:item, 10, list: list)
      end
    end
  end

  trait :with_public_and_private_lists do
    after(:create) do |user|
      private_lists = create_list(:list, 7, is_public: false, user: user)
      public_lists = create_list(:list, 8, is_public: false, user: user)
      lists = private_lists.concat(public_lists)
      lists.each do |list|
        create_list(:item, 10, list: list)
      end
    end
  end


end