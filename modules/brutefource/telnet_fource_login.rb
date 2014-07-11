#encoding: utf-8

require 'thread'

module ADONIS
module MODULE

class Telnet_fource_login < ::ADONIS::EXPLOIT::BruteFourceBase
    #command = "#{@cmd} #{@args} #{host.ip} #{@type}"
    def init
        module_id = 4006
        service_name = "telnet"
        port_str = "tcp_23"
        brute_fource_init(module_id, service_name, port_str)
        @args = "-e ns"
        return self
    end
end

end
end

