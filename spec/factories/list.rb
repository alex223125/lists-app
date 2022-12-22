# frozen_string_literal: true

FactoryBot.define do
  factory :list do
    name { 'test_name' }
    is_public { true }
  end
end

# #<List:0x000055fc7b245090
# id: 106,
#   name: "1234512345",
#   is_public: false,
#   created_at: Tue, 20 Dec 2022 18:46:34.187290000 UTC +00:00,
#   updated_at: Tue, 20 Dec 2022 20:45:29.969092000 UTC +00:00,
#   deleted_at: nil,
#   user_id: 16>,
