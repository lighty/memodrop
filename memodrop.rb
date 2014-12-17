# coding: utf-8
Dir[File.join(File.dirname(__FILE__), "lib", "**", "*.rb")].each{|f| require f }
Dir[File.join(File.dirname(__FILE__), "config", "**", "*.rb")].each{|f| require f }
require 'github/markdown'
require 'active_support/core_ext'

class String
  def nl2br
    gsub("\n", "<br/>")
  end
end

def configs
  Dir[File.join(File.dirname(__FILE__), "config", "*.rb")].map{ |f| 
    File.basename(f,".*").camelize
  }
end

Dotenv.load
configs.each do |config|
  puts "--#{config}--"
  files = Memodrop::Dropbox.new(config.classify.constantize).get_resent
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
end

# TODO
# デーモン化して1分おきに実行するようにする..


