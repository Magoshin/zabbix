#!/usr/bin/ruby

require "zabbixapi"

module ItemConvMod
  def itemTypeConv(itemTypeStr)
    rtnCode = 0
    case itemTypeStr
    when "Zabbixエージェント"
      rtnCode = 0
    when "SNMPv1エージェント"
      rtnCode = 1
    when "Zabbixトラッパー"
      rtnCode = 2
    when "シンプルチェック"
      rtnCode = 3
    when "SNMPv2エージェント"
      rtnCode = 4
    when "Zabbixインターナル"
      rtnCode = 5
    when "SNMPv3エージェント"
      rtnCode = 6
    when "Zabbixエージェント(アクティブ)"
      rtnCode = 7
    when "Zabbixアグリゲート"
      rtnCode = 8
    when "外部チェック"
      rtnCode = 10
    when "データベースモニタ"
      rtnCode = 11
    when "IPMIエージェント"
      rtnCode = 12
    when "SSHエージェント"
      rtnCode = 13
    when "TELNETエージェント"
      rtnCode = 14
    when "計算"
      rtnCode = 15
    when "JMXエージェント"
      rtnCode = 16
    when "SNMPトラップ"
      rtnCode = 17
    end

    return rtnCode
  end

  def itemValTypeConv(itemValTypeStr)
    rtnCode = 0
    case itemValTypeStr
    when "数値（浮動小数）"
      rtnCode = 0
    when "文字列"
      rtnCode = 1
    when "ログ"
      rtnCode = 2
    when "数値（整数）"
      rtnCode = 3
    when "テキスト"
      rtnCode = 4
    end

    return rtnCode
  end

  def deleteCR(orgData)
    rtnStr = orgData
    if !(orgData.nil?) then
      rtnStr = rtnStr.delete("\n")
    end

    return rtnStr
  end

  module_function :itemTypeConv
  module_function :itemValTypeConv
  module_function :deleteCR
end
