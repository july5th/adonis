#encoding: utf-8

require 'thread'

module ADONIS
module MODULE

class Smb_fource_login < ::ADONIS::EXPLOIT::BruteFourceBase
    #command = "#{@cmd} #{@args} #{host.ip} #{@type}"
    def init
        module_id = 4005
        service_name = "smb"
        port_str = "tcp_445"
        brute_fource_init(module_id, service_name, port_str)
        @args = "-e ns"
        return self
    end
end

end
end

