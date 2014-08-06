# coding: utf-8 
require 'dotenv'
require 'evernote_oauth'

Dotenv.load

developer_token = ENV['EVERNOTE_DEVELOPER_TOKEN'];
notestore_url   = ENV['EVERNOTE_NOTESTORE_URL'];
 
# Set up the NoteStore client 
client = EvernoteOAuth::Client.new(
  token: developer_token,
  sandbox: false,
)
note_store = client.note_store
 
# Make API calls
notebooks = note_store.listNotebooks
notebooks.each do |notebook|
  puts "Notebook: #{notebook.name}";
end
