require 'spec_helper'

describe Plan do
  it { should have_db_column(:name) }
  it { should have_db_column(:price) }
  it { should have_db_column(:max_storage_space) }
  it { should have_db_column(:max_bandwidth_up) }
  it { should have_db_column(:max_bandwidth_down) }
  it { should have_db_column(:daily_shared_links_quota) }

  it { should have_db_index(:name) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should ensure_length_of(:name).is_at_most(50) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:max_storage_space) }
  it { should validate_presence_of(:max_bandwidth_up) }
  it { should validate_presence_of(:max_bandwidth_down) }
  it { should validate_presence_of(:daily_shared_links_quota) }
end
