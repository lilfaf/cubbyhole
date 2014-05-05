require 'spec_helper'

describe ItemSerializer do
  let(:folder) { create(:folder) }
  let(:asset)  { create(:asset) }
  let(:folder_output) { {id: folder.id, name: folder.name, type: 'folder'}.to_json }
  let(:asset_output)  { {id: asset.id, name: asset.name, type: 'file'}.to_json }

  it { expect(ItemSerializer.new(folder).to_json).to eq(folder_output) }
  it { expect(ItemSerializer.new(asset).to_json).to eq(asset_output) }
end
