require "spec_helper"
require "dropbox"

describe Dropbox do
  it "get from dotenv" do
    dropbox = Memodrop::Dropbox.new
    expect(dropbox.developer_token).not_to be_nil
  end
end
