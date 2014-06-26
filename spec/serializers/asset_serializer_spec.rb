require 'spec_helper'

describe AssetSerializer do
  let(:asset) { create(:asset) }
  let(:output) do
    {
      id: asset.id,
      type: 'file',
      name: asset.name,
      size: asset.size,
      content_type: asset.content_type,
      etag: asset.etag,
      url: asset.asset_url,
      created_at: asset.created_at,
      updated_at: asset.updated_at,
      key: asset.key
    }.to_json
  end

  it { expect(AssetSerializer.new(asset).to_json).to eq(output) }
end
