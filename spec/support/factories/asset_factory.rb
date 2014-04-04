FactoryGirl.define do
  factory :asset do
    sequence(:name) { |i| "file#{i}" }
    key 'rails.png'
    user
  end
end
