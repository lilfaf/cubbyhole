require 'spec_helper'

describe User do
  it { should have_db_column(:username) }
  it { should have_many(:folders) }

  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
  it { should ensure_length_of(:username).is_at_most(80) }

  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should_not allow_value('test@localhost').for(:email) }

  it { should ensure_length_of(:password).is_at_least(8) }
end
