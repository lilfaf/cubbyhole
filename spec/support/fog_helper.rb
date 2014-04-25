Fog.mock!

connection = Fog::Storage.new(
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  provider: 'AWS'
)

directory = connection.directories.create(key: ENV['AWS_S3_BUCKET'])

directory.files.create(
  key: 'rails.png',
  body: File.open("#{Rails.root}/spec/support/fixtures/rails.png"),
  public: false
)
