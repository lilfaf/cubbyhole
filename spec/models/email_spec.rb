require 'spec_helper'

describe Email do
  it { should have_db_column(:body) }
  it { should validate_presence_of(:body) }

  subject { Email.new(body: 'invalid-email') }

  it { expect(subject).not_to be_valid }
end
