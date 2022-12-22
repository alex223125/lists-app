FactoryBot.define do
  factory :item do
    name { "item test title" }
    completion_status { "item completion status" }
    description { "description description description" }
    # trait :with_unfinished_order_items do
    #   after(:create) do |order|
    #     menu_item = create(:menu_item)
    #     create_list(:order_item, 5, order: order, status: 1, menu_item: menu_item)
    #   end
    # end
    #
    # trait :with_finished_order_items do
    #   after(:create) do |order|
    #     menu_item = create(:menu_item)
    #     create_list(:order_item, 5, order: order, status: 4, menu_item: menu_item)
    #   end
    # end
  end
end