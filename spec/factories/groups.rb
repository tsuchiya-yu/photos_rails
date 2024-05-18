FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Group #{n}" }

    # グループを作成するときに、関連するユーザーとグループメンバーも作成
    after(:create) do |group|
      create(:group_member, group: group)
    end
  end
end
