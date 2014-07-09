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

      opts.on("--show-target", "--show-target <open-port>", "显示开放此端口的主机，可选字段: is_vuln,is_control,#{::ADONIS::MODEL::Host.port_key_list.join(",")}") do |v|
        options['Show_target'] = v
      end
      
      opts.on("--limit", "--limit <num>", "显示数量限制") do |v|
        options['Limit'] = v
      end

      opts.on("--show-all-target", "--show-all-target", "显示所有目标") do |v|
        options['Show_all_target'] = true
      end

      opts.on("--show-exms", "--show-exms <host>", "显示目标的弱点") do |v|
        options['Show_exms'] = v
      end

      opts.on("--show-all-exms", "--show-all-exms", "显示所有弱点") do
        options['Show_all_exms'] = true
      end

      opts.on("--exploit-target", "--exploit-target <host>", "自动渗透此主机") do |v|
        options['Exploit_target'] = v
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

      opts.on("--list-exploit-modules", "--list-exploit-modules", "显示现有的Exploit模块") do
        options['List_exploit_modules'] = true
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
    print "主机数量：#{ADONIS::MODEL::Host.all.size}\n"
    exit
end

if (options['Show_target'])
    i = ::ADONIS::COMMON::Show.show_target_by_port options['Show_target'].split(","), options['Limit']
    print "\n显示完毕,共#{i}个目标.\n"
    exit
end

if (options['Show_exms'])
    i = ::ADONIS::COMMON::Show.show_exms_by_port options['Show_exms'].split(","), options['Limit']
    print "\n显示完毕,共#{i}个目标.\n"
    exit
end

if (options['Show_all_target'])
    ADONIS::COMMON::Show.show_all_target
    exit
end

if (options['Show_all_exms'])
    i = ADONIS::COMMON::Show.show_all_exms
    print "\n显示完毕,共#{i}个目标.\n"
    exit
end

if (options['List_exploit_modules'])
    i = ADONIS::COMMON::Show.show_exploit_module
    print "\n显示完毕,共#{i}个入侵插件.\n"
    exit
end

# 进入shell
if (options['Console'])
  ::Rex::Ui::Text::IrbShell.new(binding).run
  exit
end

if (options['Exploit_target'])
    ::ADONIS::EXPLOIT::Exploit.exploit options['Exploit_target']
    exit
end

if (options['Clean_test'])
    Host.where('tested_exploit_modules is not null').each do |host|
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
