#encoding: utf-8

module ADONIS
module COMMON

class Show

    ## 显示主机
    def self.show_target targets
        columns = ['IP']
        port_key_list = ::ADONIS::MODEL::Host.port_key_list
        port_key_list.each do |port_str|
            columns << port_str
        end
        #columns << "uncommon_port"
        columns << "scan_time"

        show_table = Rex::Ui::Text::Table.new(
            'Header' => '主机列表',
            'Ident' => 1,
            'Columns' => columns,
        )

        targets.each do |host|
            col = [host.ip]
            port_key_list.each do |port_str|
                col <<  (host.instance_eval(port_str) ? port_str : "--")
            end

            #col << host.uncommon_port_list.join(",")
            col << host.created_at.to_s
            show_table.add_row col
        end

        show_table.print
        return targets.size
    end

    ## 显示主机
    def self.show_exm exms
        columns = ['IP', 'MID', 'PA', 'PB', 'PC', 'PD', 'TIME', 'M_DESC']

        show_table = Rex::Ui::Text::Table.new(
            'Header' => '漏洞列表',
            'Ident' => 1,
            'Columns' => columns,
        )

        exms.each do |exm|
            module_class = ::ADONIS::EXPLOIT::Exploit.exploit_module_hash[exm.module_id.to_s]
            pa = exm.pa ? exm.pa : "--"
            pb = exm.pb ? exm.pb : "--"
            pc = exm.pc ? exm.pc : "--"
            pd = exm.pd ? exm.pd : "--"
            col = [exm.host.ip, exm.module_id, pa, pb, pc, pd, exm.created_at, module_class.desc]
            show_table.add_row col
        end

        show_table.print
        return exms.size
    end

    def self.show_target_by_port port_str, limit = nil
        show_target get_target_by_port(port_str, limit)
    end

    def self.show_exms_by_port port_str, limit = nil
        target = get_target_by_port(port_str, limit)
        exms = []
        target.each do |t|
            t.exms.each do |e|
                exms << e
            end
        end

        show_exm exms
    end

    def self.get_target_by_port port_str, limit = nil
        search_list = {}
        like_str = nil
        port_str.each do |ps|
            if ::ADONIS::MODEL::Host.new.respond_to?(ps.to_sym)
                search_list.update({ps.to_sym => true})
            else
                if ps =~ /^[\d|.|%]*$/
                    like_str = ps
                end
            end
        end

        where_str = "where(search_list)"
        where_str += ".where(\"ip like '#{like_str}'\")" if not like_str.nil?
        where_str += ".limit(limit)" if not limit.nil?

        target = ::ADONIS::MODEL::Host.class_eval where_str
        return target
    end

    def self.show_all_target
        show_target ::ADONIS::MODEL::Host.all
    end

    def self.show_all_exms
        show_exm ::ADONIS::MODEL::Exm.all
    end

    #显示exploit插件
    def self.show_exploit_module
        columns = ["ID", "种类", "名称", "端口", "描述"]
        show_table = Rex::Ui::Text::Table.new(
            'Header' => "EXPLOIT模块",
            'Ident' => 1,
            'Columns' => columns,
        )

        ::ADONIS::EXPLOIT::Exploit.exploit_module_spec_hash.each_pair do |kind, module_hash|
            module_hash.each_pair do |k, v|
                show_table.add_row [k, kind.to_s, v.name, v.port, v.desc]
            end
        end

        show_table.print
        return ::ADONIS::EXPLOIT::Exploit.exploit_module_hash.size
    end
end

end
end
