require 'spec_helper'

describe AssetSerializer do
  let(:asset) { create(:asset) }
  let(:output) do
    {
      id: asset.id,
      name: asset.name,
      size: asset.size,
      content_type: asset.content_type,
      etag: asset.etag,
      url: asset.key,
      created_at: asset.created_at,
      updated_at: asset.updated_at
    }.to_json
  end

  it { expect(AssetSerializer.new(asset).to_json).to eq(output) }
end
