#encoding: utf-8

module ADONIS
module MINGRATE

class ChangeExms < ActiveRecord::Migration
  def change
    begin
      create_table :exms do |t|
        t.integer :module_id, :null => false
        t.integer :host_id, :null => false

        t.string :pa
        t.string :pb
        t.string :pc
        t.string :pd

        t.text :alog

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
