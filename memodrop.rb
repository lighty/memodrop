# coding: utf-8
require 'dropbox_sdk'
require 'evernote_oauth'
require 'dotenv'

class String
  def nl2br
    gsub("\n", "<br/>")
  end
end

module Memodrop
  class Dropbox
    def initialize
      @client = DropboxClient.new access_token
    end
  
    def main
      @memo_dir = get_from_dropbox
      selected = select_file_after (Time.now - 60*60*24) # todo test
      #puts selected.map{|f| "#{f['path']} : "}
      contents, metadata = @client.get_file_and_metadata(selected.first['path'])
      { content: contents, filename: File.basename(metadata['path']) }
    end
  
    private
  
    def access_token
      ENV["DROPBOX_ACCESS_TOKEN"]
    end
  
    # 任意の日付以降に更新されたファイルを特定
    def select_file_after(target_time)
      @memo_dir["contents"].select do |file|
        modified_time = DateTime.parse(file["modified"]).to_time
        modified_time > target_time
      end
    end
  
    def get_from_dropbox
      @client.metadata "/memo/"
    end
  
  end

  class Evernote
    def initialize
      client = EvernoteOAuth::Client.new(
        token: developer_token,
        sandbox: false,
      )
      @note_store = client.note_store
    end

    def make_note(note_title, note_body, parent_notebook=nil)
      n_body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
      n_body += "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"
      n_body += "<en-note>#{note_body}</en-note>"

      our_note = ::Evernote::EDAM::Type::Note.new
      our_note.title = note_title
      our_note.content = n_body

      if parent_notebook && parent_notebook.guid
        our_note.notebookGuid = parent_notebook.guid
      end

      begin
        note = @note_store.createNote(our_note)
      rescue ::Evernote::EDAM::Error::EDAMUserException => edue
        puts "EDAMUserException: #{edue}"
      rescue ::Evernote::EDAM::Error::EDAMNotFoundException => ednfe
        puts "EDAMNotFoundException: Invalid parent notebook GUID"
      end

      note
    end

    private

    def developer_token
      ENV['EVERNOTE_DEVELOPER_TOKEN']
    end

  end

end

Dotenv.load
ret = Memodrop::Dropbox.new.main
Memodrop::Evernote.new.make_note(ret[:filename], ret[:content].force_encoding("UTF-8").nl2br)
