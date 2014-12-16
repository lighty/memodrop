require "dropbox"

describe Dropbox do

  before do
    @dropbox = Memodrop::Dropbox.new(Memolist)
  end

  subject(:access_token) { @dropbox.send(:access_token) }
  it "get from dotenv" do
    expect(access_token).not_to be_nil
  end

  it "can get" do
    selected = @dropbox.get_resent_one
    # ループを行う、呼び出し元で指定したブロック内で
    # evernoteとの通信をやりつつ(遅延評価) @clientは隠蔽したい
    resetnt_one = nil
    selected.each_contents do |contents, filename|
      resetnt_one = contents
    end
    expect(resetnt_one).not_to be_nil
  end

end
