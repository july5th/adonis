#encoding: utf-8

# 导入mingrate文件夹
mingrate_file_path = File.join(::ADONIS::LibarayDir, "/mingrate/*.rb")
Dir[mingrate_file_path].each do |mingrate_file|
    load mingrate_file
end

::ADONIS::MINGRATE.constants.each do |x|
    x_class = ::ADONIS::MINGRATE.class_eval x.to_s
    x_class.new.change
end
