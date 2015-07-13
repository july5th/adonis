#encoding: utf-8

module ADONIS
module MINGRATE

class ChangeInfos < ActiveRecord::Migration
  def change
    begin
      create_table :infos do |t|
        t.integer :module_id, :null => false
        t.integer :host_id, :null => false

        t.string :url

        t.string :code
        t.string :server
        t.string :header
        t.string :content

	# 是否激活
        t.integer :active_time, :null => true

        t.boolean :status, :null => false, :default => true

        t.timestamps
      end
    rescue
      print "创建info数据表失败.\n"
    end
  end
end

end
end
