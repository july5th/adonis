#encoding: utf-8

require 'thread'

module ADONIS
module MODULE

class Vnc_fource_login < ::ADONIS::EXPLOIT::BruteFourceBase
    #command = "#{@cmd} #{@args} #{host.ip} #{@type}"
    def init
        module_id = 4003
        service_name = "vnc"
        port_str = "tcp_5900"
        brute_fource_init(module_id, service_name, port_str)
        @args = "-e ns"
        return self
    end
end

end
end

