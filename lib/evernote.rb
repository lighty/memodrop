require 'dotenv'
require 'evernote_oauth'
module Memodrop
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
