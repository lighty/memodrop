require 'plist'
class DayOne
  def self.directory 
    "Apps/Day One/Journal.dayone/entries"
  end

  def self.convert(contents)
    # plist������str������ʸ���ɤ߹�����֤���markdown->html�Ѵ�������
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
