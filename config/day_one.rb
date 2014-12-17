require 'plist'
class DayOne
  def self.directory 
    "Apps/Day One/Journal.dayone/entries"
  end

  def self.convert(str_plist)
    # plist形式のstrから本文を読み込んで返す。markdown->html変換は不要
    result = Plist::parse_xml(str_plist)
    result["Entry Text"]
  end

  def self.notebook
    "dayone"
  end

end
