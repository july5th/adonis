#encoding: utf-8

module ADONIS
module MODULE
module EXPLOIT

class Ntp_rdos < ::ADONIS::EXPLOIT::Base

    def init
        module_id = "1001"
        module_name = "ntp_rdos"
        module_desc = "NTP反射式拒绝服务攻击"
        port_str = "udp_123"
        update_info(module_id, module_name, module_desc, port_str, false)
        return self
    end

    def exploit_fuc host
        return nil
    end

    def control_fuc host
        return nil
    end

end

end
end
end
