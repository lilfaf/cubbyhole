require 'spec_helper'

describe FileItem do
  it { should have_db_column(:name) }
  it { should have_db_column(:href) }
  it { should have_db_column(:folder_id) }

  it { should have_db_index([:name, :folder_id]) }

  it { should validate_presence_of(:folder_id) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:folder_id).case_insensitive }

  let!(:user) { create(:user) }
  let!(:folder) { user.folders.create(name: 'test', parent: user.root_folder) }
  let!(:file) { create(:file_item, folder: user.root_folder) }

  it "should copy a file" do
    expect{ file.copy(folder) }.to change{FileItem.count}.by(1)
  end
end
