#!/usr/bin/ruby

require "zabbixapi"
require "csv"

### テンプレート割り当て
def zbx_Hosts_Add(zbx, inputFile1)
  
  CSV.foreach(inputFile1, {:encoding => "UTF-8", :col_sep => "~" , :quote_char => "'"}) do |data|
    
    if !(data[3].nil?) then
      # テンプレートのhostid はSQLより取得
      result = `/usr/bin/mysql -N -s --user=#{DB_USER} #{DB_NAME} -e "select hostid from hosts where name = '#{data[3]}'"`
      thisTempID = result.delete("\n")
      zbx.templates.mass_add(
        :hosts_id => [zbx.hosts.get_id(:host => data[0])],
        :templates_id => [thisTempID]
      )
    end

    zbx.hosts.update(
      :hosts_id => [zbx.hosts.get_id(:host => data[0])],
      :status => 0,
    )
  end
  
  return 0
end

# ホスト追加とIF 設定変更
def zbx_Hosts_ModIf(zbx, inputFile1 , inputFile2)
  CSV.foreach(inputFile1, {:encoding => "UTF-8", :col_sep => "~" , :quote_char => "'"}) do |data|

    hostGroupNm = `awk -F '~' '{ print $1,$2 }' #{inputFile2} | sort -u | grep '#{data[0]}' | cut -f2 -d' '`

    thisHostId = `/usr/bin/mysql -N -s --user=#{DB_USER} #{DB_NAME} -e "select hostid from hosts where name = '#{data[0]}'"`

    ifAryMax = `grep -c #{data[0]} #{inputFile1}`

    # インターフェース作成用配列の作成
    CSV.foreach(inputFile1, {:encoding => "UTF-8", :col_sep => "~" , :quote_char => "'"}) do |intData|

##      if (data[0] == intData[0])
##        if (intData[1] == "SNMP") then
##          thisType = 2
##        elsif (intData[1] == "エージェント") then
##          thisType = 1
##        end

##        if (intData[5] == "主") then
##          thisMain = 1
##        elsif (intData[5] == "副") then
##          thisMain = 2
##        end

##        nowStr = "{:type => " + thisType.to_s + ", :main => " + thisMain.to_s + ", :ip => '" + intData[2] + "', :port => " + intData[4].to_s + ", :dns => '', :useip => 1 },"
##        intArrayStr = intArrayStr + nowStr
##      end

      ifAry = Array.new(ifAryMax){ Array.new(6)  }


    end

##    intArray = intArrayStr.chop 

    if (thisHostId == "") then

##puts (intArray)

      i = 0

      zbx.hosts.create(
        :host => data[0],
        :status => 1,
        :groups => [:groupid => zbx.hostgroups.get_id(:name => hostGroupNm.delete("\n"))],
        :interfaces => [
##          intArray
##{:type => 2, :main => 1, :ip => '10.149.13.154', :port => 161, :dns => '', :useip => 1 },{:type => 1, :main => 1, :ip => '10.149.13.154', :port => 10050, :dns => '', :useip => 1 }
          while i < ifAryMax do
##              if i != 0 and i != (ifAryMax - 1) then
##                ,
##              end
              
puts (i)
puts (ifAry[i][0])

              if (ifAry[i][1] == "SNMP") then
                thisType = 2
              elsif (ifAry[i][1] == "エージェント") then
                thisType = 1
              end

              if (ifAry[i][5] == "主") then
                thisMain = 1
              elsif (ifAry[i][5] == "副") then
                thisMain = 2
              end
          { 
              :type => thisType,
              :main => thisMain,
              :ip => ifAry[i][0],
              :dns => "",
              :port => ifAry[i][4],
              :useip => 1
          }
              i = i + 1
            end
##          end
        ]
##        :interfaces => [ 
##          {
##            :type => 2, 
##            :main => 1, 
##            :ip => "10.149.13.152", 
##            :dns => "",
##            :port => 161, 
##            :useip => 1 
##          }
##        ]
      )
    elsif (thisHostId != "") then
##      zbx.hosts.update(
##        :hostid => thisHostId,
##        :interfaces => [
##          {
##            :type => thisType,
##            :main => thisMain,
##            :ip => data[2],
##            :dns => "",
##            :port => data[4],
##            :useip => 1
##          }
##        ]
##      )
    end

  end

  return 0
end
