require 'spec_helper'

describe User do
  it { should have_db_column(:username) }
  it { should have_db_column(:plan_id) }
  it { should have_db_column(:admin).with_options(default: false) }

  it { should have_db_index(:plan_id) }

  it { should have_many(:folders) }
  it { should belong_to(:plan) }
  it { should have_one(:root_folder) }

  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
  it { should ensure_length_of(:username).is_at_most(80) }

  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should_not allow_value('test@localhost').for(:email) }

  it { should ensure_length_of(:password).is_at_least(8) }

  it "should create user's root folder" do
    user = build(:user)
    expect{ user.save }.to change{ Folder.count }.by(1)
    expect(user.folders.last).to eq(user.root_folder)
    expect(user.folders.last.root?).to eq(true)
  end

  it "should delete dependent folder" do
    user = create(:user)
    expect{ user.destroy }.to change{ Folder.count }.by(-1)
  end
end
