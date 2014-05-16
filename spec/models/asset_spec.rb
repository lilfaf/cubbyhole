require 'spec_helper'

describe Asset do
  it { should have_db_column(:name) }
  it { should have_db_column(:folder_id) }
  it { should have_db_column(:user_id) }
  it { should have_db_column(:processed).with_options(default: false, null: false) }
  it { should have_db_column(:key) }
  it { should have_db_column(:size) }
  it { should have_db_column(:content_type) }
  it { should have_db_column(:etag) }

  it { should have_db_index(:name) }
  it { should have_db_index(:folder_id) }
  it { should have_db_index(:user_id) }

  describe "validation" do
    before do
      Asset.any_instance.stub(:set_asset_metadata).and_return(true)
    end

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:folder_id).case_insensitive }
    it { should validate_presence_of(:key) }
    it { should validate_presence_of(:size) }
    it { should validate_presence_of(:content_type) }
    it { should validate_presence_of(:etag) }
  end

  it "should have default scope with processed true" do
    create(:asset, processed: false)
    asset = create(:asset)
    expect(Asset.all).to match_array([asset])
  end

  describe "#is_image?" do
    it "should return true if the asset is an image" do
      expect(create(:asset).is_image?).to eq(true)
    end

    it "should return false if the asset is not an image" do
      asset = create(:asset)
      asset.content_type = 'video/mp4'
      asset.save
      expect(asset.is_image?).to eq(false)
    end
  end

  it "should set asset metadata" do
    asset = create(:asset)
    expect(asset.size).to eq(123)
    expect(asset.content_type).to eq('image/png')
    expect(asset.etag).to eq('12345678')
  end

  it "should not be valid with invalid key" do
    expect(build(:asset, key: '123')).not_to be_valid
  end

  it "should copy an asset" do
    folder = create(:folder)
    asset = create(:asset)
    expect{ asset.copy(folder) }.to change{ Asset.count }.by(1)
  end
end
