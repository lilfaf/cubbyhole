require 'spec_helper'

describe FolderSerializer do
  let(:folder) { create(:folder) }
  let(:output) do
    {
      id: folder.id,
      type: 'folder',
      name: folder.name,
      created_at: folder.created_at,
      updated_at: folder.updated_at
    }.to_json
  end

  it { expect(FolderSerializer.new(folder).to_json).to eq(output) }
end
