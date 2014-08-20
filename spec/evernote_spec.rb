require "evernote"
require "unindent"

describe Evernote do

  before do
    #@evernote = Memodrop::Evernote.new
  end

  context "markdownize" do
    subject(:content) do Memodrop::Evernote.evernote_checkbox <<-EOS.unindent
        ## TODO
        - [ ] Task A
        - [x] Task B
      EOS
    end

    it "hoge" do
      expect(content).to eq(<<-EOS.unindent)
        ## TODO
        - <en-todo />Task A
        - <en-todo checked='true' />Task B
      EOS
    end
  end

end
