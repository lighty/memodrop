require 'plist'
class DayOne
  def self.directory 
    "Apps/Day One/Journal.dayone/entries"
  end

  def self.convert(str_plist)
    # plist������str������ʸ���ɤ߹�����֤���markdown->html�Ѵ�������
    result = Plist::parse_xml(str_plist)
    result["Entry Text"]
  end

  def self.notebook
    "dayone"
  end

end
