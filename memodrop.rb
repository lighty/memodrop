# coding: utf-8
Dir[File.join(File.dirname(__FILE__), "lib", "**/*.rb")].each{|f| require f }
require 'github/markdown'

class String
  def nl2br
    gsub("\n", "<br/>")
  end
end

Dotenv.load
files = Memodrop::Dropbox.new.main
puts "connected dropbox"
files.each do |file|
  puts file[:filename]
  str = file[:content].force_encoding("UTF-8")
  content = GitHub::Markdown.render_gfm(str).gsub("<br>", "<br />").gsub("<hr>", "<hr />").gsub("[ ] ", "<en-todo />").gsub("[x] ", "<en-todo checked='true' />")
  evernote = Memodrop::Evernote.new
  p content
  evernote.sync_note(file[:filename], content, evernote.select_notebook)
end
puts "connected evernote"

# TODO
# デーモン化して1分おきに実行するようにする..
