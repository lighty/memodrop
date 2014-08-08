# coding: utf-8
require 'dropbox_sdk'
require 'evernote_oauth'
require 'dotenv'
require 'github/markdown'

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
      selected = select_file_after (Time.now - 60) # 1分以内に変更があったメモが対象
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
      @client.metadata "/#{ENV['DIRNAME']}"
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

    def select_notebook
      selected_notebooks = @note_store.listNotebooks.select do |notebook|
        notebook.name == notebook_name
      end
      if selected_notebooks.empty?
        create_notebook
      else
        selected_notebooks.first
      end
    end

    def sync_note(note_title, note_body, parent_notebook=nil)
      n_body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
      n_body += "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"
      n_body += "<en-note>#{note_body}</en-note>"

      our_note = ::Evernote::EDAM::Type::Note.new title: note_title, content: n_body
      if parent_notebook && parent_notebook.guid
        our_note.notebookGuid = parent_notebook.guid
      end
      selected_note = select_note(note_title)

      begin
        if selected_note
          our_note.guid = selected_note.guid
          @note_store.updateNote(our_note)
        else
          @note_store.createNote(our_note)
        end
      rescue ::Evernote::EDAM::Error::EDAMUserException => edue
        p edue
      rescue ::Evernote::EDAM::Error::EDAMNotFoundException => ednfe
        p ednfe
      end
    end

    def select_note(title)
      filter = ::Evernote::EDAM::NoteStore::NoteFilter.new
      filter.words = "intitle:#{title}"
      spec = ::Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
      spec.includeTitle = true
      @note_store.findNotesMetadata(developer_token, filter, 0, 1, spec).notes.first
    end

    private

    def developer_token
      ENV['EVERNOTE_DEVELOPER_TOKEN']
    end

    def notebook_name
      ENV["DIRNAME"]
    end

    def create_notebook
      notebook = ::Evernote::EDAM::Type::Notebook.new 
      notebook.name = notebook_name
      @note_store.createNotebook developer_token, notebook
    end

  end

end

Dotenv.load
ret = Memodrop::Dropbox.new.main
puts "connected dropbox"
require 'cgi'
str = CGI.escapeHTML(ret[:content].force_encoding("UTF-8"))
content = GitHub::Markdown.render_gfm(str).gsub("<br>", "<br />").gsub("<hr>", "<hr />")
evernote = Memodrop::Evernote.new
evernote.sync_note(ret[:filename], content, evernote.select_notebook)
puts "connected evernote"

# TODO
# デーモン化して1分おきに実行するようにする..
