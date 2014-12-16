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
    # �롼�פ�Ԥ����ƤӽФ����ǻ��ꤷ���֥�å����
    # evernote�Ȥ��̿�����Ĥ�(�ٱ�ɾ��) @client�ϱ��ä�����
    resetnt_one = nil
    selected.each_contents do |contents, filename|
      resetnt_one = contents
    end
    expect(resetnt_one).not_to be_nil
  end

end
