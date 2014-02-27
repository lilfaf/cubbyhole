FactoryGirl.define do
  factory :folder do
    sequence(:name) { |i| "folder#{i}" }
    #user

    #before(:create) do |f|
    #  f.parent = f.user.root_folder
    #end
  end
end
