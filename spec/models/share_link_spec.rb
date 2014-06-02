require 'spec_helper'

describe ShareLink do
  it { should have_db_column(:token) }
  it { should have_db_column(:expires_at) }
  it { should have_db_column(:asset_id) }
  it { should have_db_column(:sender_id) }

  it { should have_many(:emails) }

  let!(:user) { create(:user) }
  let!(:asset) { create(:asset) }

  subject { ShareLink.create(sender: user, asset: asset) }

  it { expect(subject.token).not_to be_nil }
  it { expect(subject.expires_at).not_to be_nil }
  it { expect(ShareLink.asset_for_token(subject.token)).to eq(asset) }
end
