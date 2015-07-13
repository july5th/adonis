#encoding: utf-8

require 'thread'

module ADONIS
module MODULE

class DnsRdos < ::ADONIS::EXPLOIT::RdosBase

    def init
        module_id = 4200
        service_name = "dns"
        port_str = "udp_53"
        rdos_init(module_id, service_name, port_str)
        return self
    end

end

end
end

