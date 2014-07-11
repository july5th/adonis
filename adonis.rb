#!/usr/bin/env ruby
# -*- coding: binary -*-

adonisbase = __FILE__
while File.symlink?(adonisbase)
    adonis = File.expand_path(File.readlink(adonisbase), File.dirname(adonisbase))
end

$:.unshift(File.expand_path(File.join(File.dirname(adonisbase), 'lib')))

require 'adonis'

include ::ADONIS::MODEL

#shell = Rex::Ui::Text::IrbShell.new binding
#shell.run

require 'optparse'
class OptsConsole
  #
  # Return a hash describing the options.
  #
  def self.parse(args)
    options = {}

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: adonis.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      opts.on("--init", "--init", "初始化数据库") do 
        options['Init'] = true
      end

      opts.on("--console", "--console", "命令行模式") do 
        options['Console'] = true
      end

      opts.on("--import", "--import", "从redis中导入目标") do 
        options['Import'] = true
      end

      opts.on("--scan", "--scan <target>", "从redis中导入目标") do |v|
        options['Scan'] = v
      end
      
      opts.on("--host-num", "--host-num", "显示数据库主机数量") do |v|
        options['Host_num'] = true
      end

      opts.on("--target", "--target <open-port>", "指定目标主机，可选字段: all,is_vuln,is_control,#{::ADONIS::MODEL::Host.port_key_list.join(",")}") do |v|
        options['Target'] = v
      end

      opts.on("--limit", "--limit <num>", "显示数量限制") do |v|
        options['Limit'] = v
      end

      opts.on("--show", "--show", "显示主机列表") do 
        options['Show'] = true
      end
      
      opts.on("--show-exms", "--show-exms", "显示目标的弱点") do 
        options['Show_exms'] = true
      end

      opts.on("--show-all-exms", "--show-all-exms", "显示目标的弱点") do 
        options['Show_all_exms'] = true
      end

      opts.on("--exploit", "--exploit", "自动渗透主机") do 
        options['Exploit'] = true
      end

      opts.on("--start-exploit-pr", "--start-exploit-pr <process number>", "建立渗透测试后台进程") do |v|
        options['Start_exploit_pr'] = v
      end

      opts.on("--stop-exploit-pr", "--stop-exploit-pr", "停止渗透测试后台进程") do
        options['Stop_exploit_pr'] = true
      end

      opts.on("--del-exploit-queue", "--del-exploit-queue", "删除渗透队列内容") do
        options['Del_exploit_queue'] = true
      end

      opts.on("--list-module", "--list-module", "显示现有的Exploit模块") do
        options['List_exploit_modules'] = true
      end

      opts.on("--active-module", "--active-module <module id>", "激活此模块") do |v|
        options['Active_module'] = v
      end

      opts.on("--inactive-exploit-module", "--inactive-module <module id>", "取消此模块") do |v|
        options['Inactive_module'] = v
      end

      opts.on("--clean-test", "--clean-test", "删除已测标志") do
        options['Clean_test'] = true
      end

      opts.separator ""
      opts.separator "Common options:"
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    begin
      opts.parse!(args)
    rescue 
      puts "Invalid option, try -h for usage"
      exit
    end

    options
  end
end

module ADONIS
    Options = OptsConsole.parse(ARGV)
end

options = ADONIS::Options

if options.blank?
    puts "Invalid option, try -h for usage"
    exit
end

# 初始化数据库
if (options['Init'])
    require 'mingrate'
    exit
end

# 进入shell
if (options['Console'])
    ::Rex::Ui::Text::IrbShell.new(binding).run
    exit
end

if (options['Target'])
    targets = ::ADONIS::MODEL::Host.get_hosts options['Target'].split(","), options['Limit']
else
    targets = nil
end

if (options['Exploit'])
    if targets
        i = ::ADONIS::EXPLOIT::Exploit.exploit targets
        print "\n添加目标完毕,共#{i}个目标.\n"
    elsif (options['Import']) or (options['Scan'])
        ::ADONIS.set_auto_exploit true
    else
        print "\n请提供target参数, --target.\n"
    end
end

if (options['Import'])
    i = ADONIS::SCAN::Import.import
    print "共导入#{i}个目标\n"
    exit
end

if (options['Scan'])
    ADONIS::SCAN::Scan.run options['Scan']
    exit
end

if (options['Host_num'])
    if targets
        print "主机数量：#{targets.size}\n"
    else
        print "主机数量：#{ADONIS::MODEL::Host.all.size}\n"
    end
    exit
end

if (options['Show'])
    if targets
        ::ADONIS::COMMON::Show.show_target targets
        print "\n显示完毕,共#{targets.size}个目标.\n"
    else
        print "\n请提供target参数, --target.\n"
    end
    exit
end

if (options['Show_exms'])
    if targets
        i = ::ADONIS::COMMON::Show.show_exms_by_host targets
        print "\n显示完毕,共#{i}个目标.\n"
    else
        print "\n请提供target参数, --target.\n"
    end
    exit
    
end

if (options['Show_all_exms'])
    i = ::ADONIS::MODEL::Exm.all
    ::ADONIS::COMMON::Show.show_exm i
    print "\n显示完毕,共#{i.size}个目标.\n"
end

if (options['List_exploit_modules'])
    i = ADONIS::COMMON::Show.show_exploit_module
    print "\n显示完毕,共#{i}个入侵插件.\n"
    exit
end

if (options['Clean_test'])
    tmp_host_list = []
    if targets
        targets.each do |host|
            tmp_host_list << host if not (host.tested_exploit_modules == nil)
        end
    else
        tmp_host_list = Host.where('tested_exploit_modules is not null')
    end

    tmp_host_list.each do |host|
        host.tested_exploit_modules = nil
        host.history = nil
        host.save
        p "delete #{host.ip} tested status"
    end

    exit
end

if (options['Start_exploit_pr'])
    1.upto(options['Start_exploit_pr'].to_i) do |i|
        IO.popen("nohup ruby ./start_exploit.rb > /dev/null &")
    end
    exit
end

if (options['Stop_exploit_pr'])
    `./stop_exploit.sh`
    exit
end

if (options['Del_exploit_queue'])
    host_id = ::ADONIS::COMMON::Queue.lpop "exploit_queue"
    while not host_id.nil?
        p "delete queue host_id: #{host_id}"
        host_id = ::ADONIS::COMMON::Queue.lpop "exploit_queue"
    end
    exit
end

if (options['Active_module'])
    module_id_list = ::ADONIS::EXPLOIT::Exploit.get_moduled_list_by_str options['Active_module']
    ::ADONIS::EXPLOIT::Exploit.active_module module_id_list
end

if (options['Inactive_module'])
    module_id_list = ::ADONIS::EXPLOIT::Exploit.get_moduled_list_by_str options['Inactive_module']
    ::ADONIS::EXPLOIT::Exploit.inactive_module module_id_list
end
