#encoding: utf-8

require 'active_record'
require 'redis'
require 'yaml'

require 'env'
require 'rex'

require 'config'

# 导入model文件夹
model_file_path = File.join(::ADONIS::LibarayDir, "/adonis/model/*.rb")
Dir[model_file_path].each do |model_file|
    load model_file
end

# 导入公共库
require 'adonis/scan/ip.rb'
require 'adonis/scan/import.rb'
require 'adonis/scan/scan.rb'

# 导入exploit module文件夹
module_file_path = File.join(::ADONIS::LibarayDir, "/adonis/common/*.rb")
Dir[module_file_path].each do |module_file|
    load module_file
end

require 'adonis/exploit/base.rb'
require 'adonis/exploit/module_node.rb'
require 'adonis/exploit/exploit.rb'

# 导入exploit module文件夹
module_file_path = File.join(::ADONIS::LibarayDir, "/adonis/exploit/module/*.rb")
Dir[module_file_path].each do |module_file|
    load module_file
end

# 生成exploit module树
::ADONIS::EXPLOIT::ModuleHelper.create_module_tree

