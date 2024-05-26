FactoryBot.define do
  factory :media_item_comment do
    comment { "Test comment" }
    user
    media_item
  end
end
