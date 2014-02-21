FactoryGirl.define do
  factory :entry do
    sequence(:name) { |i| "name#{i}" }
    user

    factory :folder, class: Folder do
    end

    factory :filo, class: Filo do
      # add fake href
    end
  end
end
