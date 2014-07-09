#encoding: utf-8

module ADONIS
module MODULE
module EXPLOIT

class Snmp_rdos < ::ADONIS::EXPLOIT::Base

    def init
        module_id = "1002"
        module_name = "snmp_rdos"
        module_desc = "SNMP反射式拒绝服务攻击"
        port_str = "udp_161"
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

