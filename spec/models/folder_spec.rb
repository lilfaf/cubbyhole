require 'spec_helper'

describe Folder do
  it { should have_db_column(:name) }
  it { should have_db_column(:user_id) }
  it { should have_db_column(:parent_id) }
  it { should have_db_column(:lft) }
  it { should have_db_column(:rgt) }
  it { should have_db_column(:depth) }

  it { should have_db_index(:user_id) }
  it { should have_db_index(:parent_id) }
  it { should have_db_index(:lft) }
  it { should have_db_index(:rgt) }
  it { should have_db_index(:depth) }
  it { should have_db_index([:name, :parent_id]) }

  it { should have_many(:file_items).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:parent_id).case_insensitive }

  let!(:user) { user = create(:user) }

  it "should destroy dependent file items" do
    parent = create(:folder, user: user)
    2.times { create(:file_item, folder: parent) }
    expect{ parent.destroy }.to change{ FileItem.count }.by(-2)
  end

  describe "copying folder" do
    %w(source destination).each do |name|
      let!(name.to_sym) { create(:folder, user: user) }
    end

    let!(:subfolder) { create(:folder, user: user, parent: source) }

    it "should duplicate dependent file items" do
      2.times { create(:file_item, folder: subfolder) }
      expect{ source.copy(destination) }.to change{ FileItem.count }.by(2)
    end

    it "should duplicate subfolders" do
      expect{ source.copy(destination) }.to change{ Folder.count }.by(2)
    end
  end
end
