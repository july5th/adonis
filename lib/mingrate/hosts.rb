#encoding: utf-8

module ADONIS
module MINGRATE

class ChangeHosts < ActiveRecord::Migration
  def change
    begin
      create_table :hosts do |t|
        t.string :ip, :null => false

        ########## 主机基本特征 ##########
        ## 开放端口list，这里只存非主要端口
        t.string :open_ports
        ## 主机特征
        t.string :finger
        ## 主机版本
        t.string :os
        ## 历史记录
        t.text :history

        ######### 渗透插件 ###########
        ## 可渗透的插件
        t.string :exploit_modules
        ## 测试过的插件,list
        t.string :tested_exploit_modules

        ######### 主机状态 ###########
        t.boolean :is_alive, :null => false, :default => true
        t.boolean :is_vuln, :null => false, :default => false
        t.boolean :is_control, :null => false, :default => false

        t.timestamps
      end

      add_index :hosts, :ip,   :unique => true
    rescue
      print "创建主机数据表失败,查看是否新增字段.\n"
    end

    tmpHost = ::ADONIS::MODEL::Host.new
    ::ADONIS::MODEL::Host.port_key_list.each do |port|
        #CHECK PORT STRING
        port_list = port.split("_")
        next if port_list.blank? or port_list.size != 2
        next if port_list[0] != "tcp" and port_list[0] != "udp"
        next if port_list[1].to_i.to_s != port_list[1]
        unless tmpHost.respond_to? port 
            add_column :hosts, port.to_sym, :boolean, :default => false
        end
    end

  end
end

end
end
