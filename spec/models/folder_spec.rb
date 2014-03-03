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

  it "should require a parent folder" do
    expect(user.folders.build(name: 'test')).not_to be_valid
  end

  it "should prevent root deletion from being deleted" do
    expect{ user.root_folder.destroy }.to raise_error(Errors::ForbiddenOperation)
  end

  it "should destroy dependent file items" do
    parent = user.folders.create(name: 'test', parent_id: user.root_folder.id)
    2.times { create(:file_item, folder: parent) }
    expect{ parent.destroy }.to change{ FileItem.count }.by(-2)
  end

  describe "copying folder" do
    %w(source destination).each do |name|
      let!(name.to_sym) { user.folders.create(name: name, parent_id: user.root_folder.id) }
    end

    let!(:subfolder) { user.folders.create(name: 'sub', parent: source) }

    it "should duplicate dependent file items" do
      2.times { create(:file_item, folder: subfolder) }
      expect{ source.copy(destination) }.to change{ FileItem.count }.by(2)
    end

    it "should duplicate subfolders" do
      expect{ source.copy(destination) }.to change{ Folder.count }.by(2)
    end
  end
end