require 'spec_helper'

describe Filo do
  let(:filo) { create(:filo) }
  let(:folder) { create(:folder) }

  it "cant be the child of an other file" do
    child = build(:filo, parent_id: filo.id)
    expect(child).not_to be_valid
    expect(child.errors[:parent].first).to eq('is invalid')
  end

  it "can be created within a folder" do
    expect(create(:filo, parent_id: folder.id)).to be_valid
  end

  it "can be created at root path" do
    expect(create(:filo, parent_id: nil)).to be_valid
  end
end
