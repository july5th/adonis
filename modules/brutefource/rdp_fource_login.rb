#encoding: utf-8

require 'thread'

module ADONIS
module MODULE

class Rdp_fource_login < ::ADONIS::EXPLOIT::BruteFourceBase
    #command = "#{@cmd} #{@args} #{host.ip} #{@type}"
    def init
        module_id = 4000
        service_name = "rdp"
        port_str = "tcp_3389"
        brute_fource_init(module_id, service_name, port_str)
        @args = "-t 1 -e ns"
        return self
    end
end

end
end

