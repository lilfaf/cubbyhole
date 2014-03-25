FactoryGirl.define do
  factory :file_item do
    sequence(:name) { |i| "file#{i}" }
    user
  end
end
