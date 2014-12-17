# coding: utf-8
Dir[File.join(File.dirname(__FILE__), "lib", "**", "*.rb")].each{|f| require f }
Dir[File.join(File.dirname(__FILE__), "config", "**", "*.rb")].each{|f| require f }
require 'github/markdown'

class String
  def nl2br
    gsub("\n", "<br/>")
  end
end

Dotenv.load
files = Memodrop::Dropbox.new(Memolist).get_resent
puts "connected dropbox"
files.each_contents do |contents, filename|
  puts filename
  str = contents.force_encoding("UTF-8")
  evernote = Memodrop::Evernote.new(Memolist)
  content = evernote.markdownize str
  p content
  evernote.sync_note(filename, content, evernote.select_notebook)
end
puts "connected evernote"

# TODO
# デーモン化して1分おきに実行するようにする..
