require 'spec_helper'

describe Entry do
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:type) }
  it { should have_db_column(:href) }
  it { should have_db_index(:ancestry).unique(true) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(250) }

  let!(:entry) { create(:entry) }

  it "shoud ensure uniqueness of name within the parent container" do
    expect(build(:entry, name: entry.name.upcase)).not_to be_valid
  end
end
