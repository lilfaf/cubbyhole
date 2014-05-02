describe CurrentUserSerializer do
  let!(:user) { create(:user) }
  let(:output) do
    {
      id: user.id,
      email: user.email,
      username: user.username,
      auth_token: user.token
    }.to_json
  end

  before { user.generate_access_token! }

  it "should serialize to a valid json" do
    expect(CurrentUserSerializer.new(user).to_json).to eq(output)
  end
end
