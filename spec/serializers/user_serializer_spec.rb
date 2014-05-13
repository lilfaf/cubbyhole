describe UserSerializer do
  let!(:user) { create(:user) }
  let(:output) do
    {
      id: user.id,
      email: user.email,
      username: user.username
    }.to_json
  end

  it "should serialize to a valid json" do
    expect(UserSerializer.new(user).to_json).to eq(output)
  end
end
