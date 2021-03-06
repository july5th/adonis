#encoding: utf-8

module ADONIS
module MINGRATE

class ChangeExms < ActiveRecord::Migration
  def change
    begin
      create_table :exms do |t|
        t.integer :module_id, :null => false
        t.integer :host_id, :null => false

        t.string :p1
        t.string :p2
        t.string :p3
        t.string :p4
        t.string :p5

        t.text :alog

	# 是否激活
        t.integer :active_time, :null => true

        t.boolean :status, :null => false, :default => true

        t.timestamps
      end
    rescue
      print "创建exms数据表失败.\n"
    end
  end
end

end
end
