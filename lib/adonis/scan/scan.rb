#encoding: utf-8

require 'thread'

module ADONIS
module SCAN

class Scan
    def self.run target
        cmd = File.join(::ADONIS::BinDir, "masscan")
        port_list = []
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
        command = "#{cmd} #{args} #{target}"

        print "启动导入进程\n"
        thread = Thread.new {::ADONIS::SCAN::Import.run}

        print "执行扫描命令: #{command}\n"
        `#{command}`

        print "请等待10秒\n"
        sleep 10
        thread.kill
        print "扫描结束\n"

    end
end

end
end

