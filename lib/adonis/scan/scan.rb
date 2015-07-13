#encoding: utf-8

require 'thread'

module ADONIS
module SCAN

class Scan
    def self.run target, tag = nil
        cmd = File.join(::ADONIS::BinDir, "masscan")
        port_list = []
	target_host_list = []

	(Rex::Socket::RangeWalker.new target).each do |ip|
		target_host_list.push ip
	end

        ::ADONIS::MODEL::Host.port_key_list.each do |port|
            lport = port.split("_")
            if lport[0] == "tcp"
                port_list.push lport[1]
            elsif lport[0] == "udp"
                port_list.push "U:#{lport[1]}"
            end
        end

        #args = "-p#{port_list.join(',')} --rate 30 -oR 127.0.0.1"
        args = "-p#{port_list.join(',')} -oR 127.0.0.1"
        command = "sudo #{cmd} #{args} #{target}"

        print "启动导入进程\n"

	import = ::ADONIS::SCAN::Import.new
        thread = Thread.new {import.run}

        print "执行扫描命令: #{command}\n"
        `#{command}`

        print "请等待导入进程结束\n"
	import.clear target_host_list, tag
        thread.join
        print "扫描结束\n"

    end
end

end
end

