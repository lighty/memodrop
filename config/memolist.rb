class Memolist
  def self.directory 
    "memo"
  end

  def self.convert(contents)
    contents
  end

  def self.notebook
    "memolist"
  end

  def self.filename(metadata, contents)
    File.basename(metadata['path'])
  end

end
