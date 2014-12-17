require 'plist'
class DayOne
  def self.directory 
    "Apps/Day One/Journal.dayone/entries"
  end

  def self.convert(contents)
    # plist形式のstrから本文を読み込んで返す。markdown->html変換は不要
    result = Plist::parse_xml(contents)
    result["Entry Text"]
  end

  def self.notebook
    "dayone"
  end

  def self.filename(metadata, contents)
    result = Plist::parse_xml(contents)
    result["Creation Date"].to_s
  end

end
