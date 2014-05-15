FactoryGirl.define do
  factory :asset do
    sequence(:name) { |i| "file#{i}" }
    key 'https://s3.amazonaws.com/cubbyhole/uploads%2F1400113238241-hjl8318evbihpvi-8be74e30efb7509bd411b824c86437e1%2FRails.png'
    size 123
    content_type 'image/png'
    etag '12345678'
    user

    after(:build) { |asset| asset.class.skip_callback(:validation, :before, :set_asset_metadata) }
  end
end
