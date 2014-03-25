require 'spec_helper'

describe FileItem do
  it { should have_db_column(:name) }
  it { should have_db_column(:href) }
  it { should have_db_column(:folder_id) }
  it { should have_db_column(:user_id) }

  it { should have_db_index(:name) }
  it { should have_db_index(:folder_id) }
  it { should have_db_index(:user_id) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:folder_id).case_insensitive }

  it "should copy a file" do
    folder = create(:folder)
    file = create(:file_item)
    expect{ file.copy(folder) }.to change{ FileItem.count }.by(1)
  end
end
