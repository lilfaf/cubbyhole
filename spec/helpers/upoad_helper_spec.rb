require 'spec_helper'

RSpec::Matchers.define :be_base64 do
  match { |a| a.match(/^[A-Za-z0-9+\/=]+\Z/) }
end

describe UploadHelper do
  include UploadHelper

  it { expect(policy).to be_base64 }
  it { expect(signature).to be_base64 }
end
