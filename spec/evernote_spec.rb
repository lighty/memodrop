require "evernote"

describe Evernote do

  before do
    #@evernote = Memodrop::Evernote.new
  end

  context "markdownize" do
    subject(:content) do Memodrop::Evernote.evernote_checkbox <<-EOS
        ## TODO
        - [ ] Task A
        - [x] Task B
      EOS
    end

    it "hoge" do
      expect(:content).to eq(<<-EOS)
        ## TODO
        - [ ] Task A
        - [x] Task B
      EOS
    end
  end

end
