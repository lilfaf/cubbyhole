FactoryGirl.define do
  factory :folder do
    sequence(:name) { |i| "folder#{i}" }
    user
  end
end
