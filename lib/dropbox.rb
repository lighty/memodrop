require 'dropbox_sdk'
require 'dotenv'
require "/Users/usr0600165/work/memodrop/config/memolist.rb"

module Memodrop
  class Dropbox
    def initialize(config)
      Dotenv.load
      @config = config
      @client = DropboxClient.new access_token
    end
  
    def get_resent
      get_contents {
        select_file_after(Time.now - 60) # 1分以内に変更があったメモが対象
      }
    end

    def get_resent_one
      get_contents { [ @memo_dir["contents"].first ] }
    end
  
    private

    def get_contents
      @memo_dir = get_metadata
      selected = yield
      client = @client
      selected.define_singleton_method(:each_contents) do |&block|
        selected.each do |file|
          contents, metadata = client.get_file_and_metadata(file['path'])
          block.call contents, File.basename(metadata['path'])
        end
      end
      selected
    end
  
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

    def get_metadata
      @client.metadata target_directory
    end

    def target_directory
      "/#{@config.directory}"
    end

  end
end
