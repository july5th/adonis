#encoding: utf-8

require 'thread'

module ADONIS
module MODULE

class Ftp_fource_login < ::ADONIS::EXPLOIT::BruteFourceBase
    #command = "#{@cmd} #{@args} #{host.ip} #{@type}"
    def init
        module_id = 4004
        service_name = "ftp"
        port_str = "tcp_21"
        brute_fource_init(module_id, service_name, port_str)
        @args = "-e ns"
        return self
    end
end

end
end

