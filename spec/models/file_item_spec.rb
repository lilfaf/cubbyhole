require 'spec_helper'

describe FileItem do
  it { should validate_presence_of(:folder_id) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:folder_id).case_insensitive }
end
