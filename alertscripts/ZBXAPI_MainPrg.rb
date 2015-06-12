#!/usr/bin/ruby

SCRIPT_DIR_MAIN = '/etc/zabbix/alertscripts/'
FILES_DIR = SCRIPT_DIR_MAIN + 'files/'
INPUT_DIR = SCRIPT_DIR_MAIN + 'input/'
FUNC_DIR = SCRIPT_DIR_MAIN + 'func/'

require "zabbixapi"
require FILES_DIR + 'ZBXAPI_SrvDataFile.rb'
require FUNC_DIR + 'ZBXAPI_HostGroups.rb'
require FUNC_DIR + 'ZBXAPI_Template.rb'
require FUNC_DIR + 'ZBXAPI_Hosts.rb'
require FUNC_DIR + 'Mod_ZBXAPI_DataConv.rb'

Zabbix_url = "http://" + Zabbix_IPAddr + "/zabbix/api_jsonrpc.php"
 
# サーバ接続処理
zbx = ZabbixApi.connect(
        :url => Zabbix_url , :user => Zabbix_id , :password => Zabbix_passwd
)

puts " ****** ZBXAPI START ******"

## ホストグループの削除
arg1 = INPUT_DIR + 'ZBXAPI_INPUT_hostgroups.txt'
a = zbx_Hostgroup_Delete(zbx,arg1)

## ホストグループの追加
arg1 = INPUT_DIR + 'ZBXAPI_INPUT_hostgroups.txt'
arg2 = FILES_DIR + 'ZBXAPI_DefaultHostGrpList.txt'
a = zbx_Hostgroup_Add(zbx,arg1,arg2)

## テンプレートの追加
arg1 = INPUT_DIR + 'ZBXAPI_INPUT_template.txt'
a = zbx_Template_Add(zbx,arg1)

## ホストのIF設定変更
arg1 = INPUT_DIR + 'ZBXAPI_INPUT_host-interface.txt'
arg2 = INPUT_DIR + 'ZBXAPI_INPUT_host-template.txt'
a = zbx_Hosts_ModIf(zbx, arg1, arg2)

## テンプレート割り当て
arg1 = INPUT_DIR + 'ZBXAPI_INPUT_host-template.txt'
a = zbx_Hosts_Add(zbx,arg1)

## アイテムの追加
arg1 = INPUT_DIR + 'ZBXAPI_INPUT_template-items.txt'
a = zbx_Template_SetItems(zbx, arg1)

puts " ****** ZBXAPI END  ******"
