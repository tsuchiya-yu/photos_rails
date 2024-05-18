FactoryBot.define do
  factory :album do
    sequence(:name) { |n| "Album #{n}" }
    association :group
  end
end
