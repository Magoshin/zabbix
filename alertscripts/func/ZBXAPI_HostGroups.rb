#!/usr/bin/ruby

require "zabbixapi"

### ホストグループ追加
def zbx_Hostgroup_Add(zbx, inputFile, defaultList)

  open( inputFile ) {|data|

    while thisHostgroupNameFrt = data.gets

      thisHostgroupName = thisHostgroupNameFrt.delete("\n")
      targetWord = "^" + thisHostgroupName + "$"

      defaultGrpCHk = `grep -oc "#{targetWord}" #{defaultList}`

      if defaultGrpCHk.to_i == 0 then
        thisid = zbx.hostgroups.get_id(:name => thisHostgroupName)
        if thisid.nil?
            zbx.hostgroups.create_or_update(:name => thisHostgroupName)
        end
      end
    end
  }

  return 0
end

### ホストグループ削除
def zbx_Hostgroup_Delete(zbx, inputFile)

  alldata = zbx.hostgroups.all
  nowDB_Array = alldata.keys

  nowDB_Array.each{|var|

    chkWord = "^" + var + "$"
    deleteChk = `grep -oc "#{chkWord}" #{inputFile}`

###### 検討中！
  if deleteChk.to_i == 0 then
    targetId = zbx.hostgroups.dump_by_id(:name => var)
##    zbx.hostgroups.delete(:groupid => 94)
  end
#####

  }
end
