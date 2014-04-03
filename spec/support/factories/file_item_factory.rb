FactoryGirl.define do
  factory :file_item do
    sequence(:name) { |i| "file#{i}" }
    key 'rails.png'
    user
  end
end
