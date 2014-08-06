# coding: utf-8
require 'dropbox_sdk'
require 'dotenv'

class Memodrop
  def initialize
    @client = DropboxClient.new access_token
  end

  def main
    @memo_dir = get_from_dropbox
    selected = select_file_after (Time.now - 60*60*24) # todo test
    puts selected.map{|f|f["path"]}
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

  #contents, metadata = client.get_file_and_metadata('/memo/2014-03-30-study.md')
end

Dotenv.load
Memodrop.new.main
