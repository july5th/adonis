#encoding: utf-8

require 'thread'

module ADONIS
module MODULE

class Ssh_brute_fource_login < ::ADONIS::EXPLOIT::BruteFourceBase
    #command = "#{@cmd} #{@args} #{host.ip} #{@type}"
    def init
        module_id = 4001
        service_name = "ssh"
        port_str = "tcp_22"
        brute_fource_init(module_id, service_name, port_str)
        @args = "-t 4 -e ns"
        return self
    end

end

end
end

