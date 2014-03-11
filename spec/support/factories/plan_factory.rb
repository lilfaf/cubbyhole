FactoryGirl.define do
  factory :plan do
    sequence(:name) { |i| "plan#{i}" }
    price "9.99"
    max_storage_space "5"
    max_bandwidth_up "200"
    max_bandwidth_down "1000"
    daily_shared_links_quota "3"
  end
end