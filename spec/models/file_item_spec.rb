require 'spec_helper'

describe FileItem do
  it { should have_db_column(:name) }
  it { should have_db_column(:href) }
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
      FileItem.any_instance.stub(:set_asset_metadata).and_return(true)
    end

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:folder_id).case_insensitive }
    it { should validate_presence_of(:key) }
    it { should validate_presence_of(:size) }
    it { should validate_presence_of(:content_type) }
    it { should validate_presence_of(:etag) }
  end

  it "should have default scope with processed true" do
    create(:file_item, processed: false)
    file = create(:file_item)
    expect(FileItem.all).to match_array([file])
  end

  describe "#post_processing_required?" do
    it "should return true if the asset is an image" do
      expect(create(:file_item).post_processing_required?).to eq(true)
    end

    it "should return false for other file types" do
      file = create(:file_item)
      file.content_type = 'video/mp4'
      file.save
      expect(file.post_processing_required?).to eq(false)
    end
  end

  it "should set asset metadata" do
    file = create(:file_item)
    expect(file.size).to eq(84889)
    expect(file.content_type).to eq('image/png')
    expect(file.etag).to eq('110c700b3c4b02286cbfa3b700af8a57')
  end

  it "should not be valid with invalid key" do
    expect(build(:file_item, key: '123')).not_to be_valid
  end

  it "should copy a file" do
    folder = create(:folder)
    file = create(:file_item)
    expect{ file.copy(folder) }.to change{ FileItem.count }.by(1)
  end
end
