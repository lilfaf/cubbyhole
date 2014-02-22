require 'spec_helper'

describe Folder do
  it { should have_db_column(:name) }
  it { should have_db_column(:ancestry) }
  it { should have_db_column(:user_id) }
  it { should have_db_index(:user_id) }
  it { should have_db_index(:ancestry).unique(true) }

  it { should have_many(:file_items).dependent(:destroy) }
  it { should belong_to(:user) }

  let!(:folder) { create(:folder) }

  it "should require name to be set" do
    expect(build(:folder, name: '', parent_id: folder.id))
  end

  it "should require unique name in ancestor scope" do
    child = create(:folder, parent_id: folder.id)
    expect(build(:folder, name: child.name.upcase, parent_id: folder.id)).not_to be_valid
  end

  it "should destroy dependent file items" do
    2.times { create(:file_item, folder: folder) }
    expect{ folder.destroy }.to change{ FileItem.count }.by(-2)
  end
end
