#!/usr/bin/ruby

require "zabbixapi"
require "csv"

### テンプレート追加 #####
## data[0]:テンプレート名
## data[1]:ホストグループ名
##########################
def zbx_Template_Add(zbx, inputFile)
  CSV.foreach(inputFile) do |data|
    zbx.templates.create_or_update(
      :host => data[0],
      :groups => [:groupid => zbx.hostgroups.get_id(:name => data[1])]
    )
  end
end

### アイテム設定 #####
##########################
def zbx_Template_SetItems(zbx, inputFile)

##n = 1

  # テンプレートにアイテムを追加
  CSV.foreach(inputFile, {:encoding => "UTF-8", :col_sep => "~" , :quote_char => "'"}) do |data|

##puts ("何週目？")
##puts (n)

    # 各種データの取得と整形
    tmplName = ItemConvMod.deleteCR(data[0])
    itemName = ItemConvMod.deleteCR(data[1])
    itemType = ItemConvMod.deleteCR(data[2])
    snmpComunity = ItemConvMod.deleteCR(data[3])
    snmpOID = ItemConvMod.deleteCR(data[4])
    snmpPort = ItemConvMod.deleteCR(data[5])
    snmpv3SecName = ItemConvMod.deleteCR(data[6])
    snmpv3SecLevel = ItemConvMod.deleteCR(data[7])
    snmpv3SecCpass = ItemConvMod.deleteCR(data[8])
    snmpv3SecPpass = ItemConvMod.deleteCR(data[9])
    itemKeys = ItemConvMod.deleteCR(data[10])
    itemIntv = ItemConvMod.deleteCR(data[11])
    itemHist = ItemConvMod.deleteCR(data[12])
    itemTrnd = ItemConvMod.deleteCR(data[13])
    itemDtype = ItemConvMod.deleteCR(data[14])
    itemDecimal = ItemConvMod.deleteCR(data[15])
    itemUnit = ItemConvMod.deleteCR(data[16])
    itemIPMISens = ItemConvMod.deleteCR(data[17])
    itemSavefunc = ItemConvMod.deleteCR(data[18])
    itemTrapHost = ItemConvMod.deleteCR(data[19])
    itemApplication = ItemConvMod.deleteCR(data[20])
    itemFormula = ItemConvMod.deleteCR(data[21])
    itemUseMulti = ItemConvMod.deleteCR(data[22])
    itemMultiplier = ItemConvMod.deleteCR(data[23])
    itemStatus = ItemConvMod.deleteCR(data[24])

    # アイテムのタイプをコード取得
    itemTypeCode = ItemConvMod.itemTypeConv(itemType)
    # アイテムの型をコードで取得
    itemValTypeCode = ItemConvMod.itemValTypeConv(itemDtype)

    # テンプレートのhostid はSQLより取得
    result = `/usr/bin/mysql -N -s --user=#{DB_USER} #{DB_NAME} -e "select hostid from hosts where name = '#{tmplName}'"`
    thisTempID = result.delete("\n")

    # テンプレートのアプリケーションIDはSQLより取得
    result = `/usr/bin/mysql -N -s --user=#{DB_USER} #{DB_NAME} -e "select applicationid from applications where name = '#{itemApplication}' AND hostid = '#{thisTempID}'"`

    if (result == "") then
      # アプリケーションの登録
      thisApliID = zbx.applications.create(
        :name => itemApplication,
        :hostid => thisTempID
      )

    else
      # テンプレートのアプリケーションIDはSQLより取得
      result = `/usr/bin/mysql -N -s --user=#{DB_USER} #{DB_NAME} -e "select applicationid from applications where name = '#{itemApplication}' AND hostid = '#{thisTempID}'"`
      thisApliID = ItemConvMod.deleteCR(result.delete("\n"))
    end

##puts ("itemName:" + itemName)
##puts ("itemKeys:" + itemKeys)
##puts ("thisTempID:")
##puts (thisTempID)
##puts ("thisApliID:")
##puts (thisApliID)

    # アイテムの追加
    itemId = zbx.items.create_or_update(
      :name => itemName,
      :key_ => itemKeys,
      :type => itemTypeCode,
      :value_type => itemValTypeCode,
      :delay => itemIntv,
      :history => itemHist,
      :trends => itemTrnd,
      :hostid => thisTempID,
      :applications => [ thisApliID ]
    )

##puts ("*************************")
##n = n + 1

  end
end
