require "dropbox"

describe Dropbox do

  before do
    @dropbox = Memodrop::Dropbox.new
  end

  subject(:access_token) { @dropbox.send(:access_token) }
  it "get from dotenv" do
    expect(:access_token).not_to be_nil
  end

end
