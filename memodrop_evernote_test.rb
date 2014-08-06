# coding: utf-8 
require 'dotenv'
require 'evernote_oauth'

Dotenv.load

developer_token = ENV['EVERNOTE_DEVELOPER_TOKEN'];
notestore_url   = ENV['EVERNOTE_NOTESTORE_URL'];
 

def make_note(note_store, note_title, note_body, parent_notebook=nil)
 
  n_body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  n_body += "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"
  n_body += "<en-note>#{note_body}</en-note>"
 
  our_note = Evernote::EDAM::Type::Note.new
  our_note.title = note_title
  our_note.content = n_body
 
  if parent_notebook && parent_notebook.guid
    our_note.notebookGuid = parent_notebook.guid
  end
 
  begin
    note = note_store.createNote(our_note)
  rescue Evernote::EDAM::Error::EDAMUserException => edue
    puts "EDAMUserException: #{edue}"
  rescue Evernote::EDAM::Error::EDAMNotFoundException => ednfe
    puts "EDAMNotFoundException: Invalid parent notebook GUID"
  end
 
  note
end

# Set up the NoteStore client 
client = EvernoteOAuth::Client.new(
  token: developer_token,
  sandbox: false,
)
note_store = client.note_store

make_note(note_store, "test_from_memodrop" , "boddyyyyy")
 
