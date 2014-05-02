shared_examples_for 'token_authenticatable' do
  let(:model) { create(described_class.name.underscore.to_sym) }

  describe '#generate_access_token!' do
    it { expect{ model.generate_access_token! }.to change{ Doorkeeper::AccessToken.count }.by(1) }
  end

  describe '#token' do
    before { model.generate_access_token! }
    it { expect(model.token).to match(/^[A-Za-z0-9+\/=]+\Z/) }
  end

  describe '#delete_token' do
    before { 2.times{ model.generate_access_token! } }
    it { expect{ model.delete_token }.to change{ Doorkeeper::AccessToken.count }.by(-2) }
  end

  describe '#from_token' do
    before { model.generate_access_token! }
    it { expect(described_class.from_token(model.access_tokens.first)).to eq(model) }
  end
end
