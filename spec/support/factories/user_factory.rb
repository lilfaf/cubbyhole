FactoryGirl.define do
  factory :user do
    sequence(:username) { |i| "user#{i}" }
    sequence(:email) { |i| "test#{i}@example.com" }
    password "12345678"
    password_confirmation "12345678"

    factory :admin do
      admin true
    end
  end
end
