FactoryGirl.define do
  factory :file_item do
    sequence(:name) { |i| "file#{i}" }
    folder
  end
end
