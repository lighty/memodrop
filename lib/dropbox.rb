require 'dropbox_sdk'
require 'dotenv'
module Memodrop
  class Dropbox
    def initialize
      @client = DropboxClient.new access_token
    end
  
    def main
      @memo_dir = get_from_dropbox
      selected = select_file_after (Time.now - 60) # 1分以内に変更があったメモが対象
      selected.map do |file|
        contents, metadata = @client.get_file_and_metadata(file['path'])
        puts file['path']
        { content: contents, filename: File.basename(metadata['path']) }
      end
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
end
