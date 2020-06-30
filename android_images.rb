#! /usr/bin/env ruby

require 'fileutils'

def help_message
  "Usage: android_images.rb SOURCE_DIR DESTINATION_DIR\nWhere SOURCE_DIR looks like: PROJECT/appiconmaker/Android\nWhere DESTINATION_DIR looks like: PROJECT/demoapp/src/main/res"
end

def path(base, name)
  File.expand_path(File.join(base, name))
end

def main
  source_dir = ARGV.first
  dest_dir = ARGV.last

  file_map = [
    ["Icon-72.png", "drawable/notification_icon.png"],
    ["Icon-72.png", "mipmap-hdpi/ic_launcher.png"],
    ["Icon-48.png", "mipmap-mdpi/ic_launcher.png"],
    ["Icon-96.png", "mipmap-xhdpi/ic_launcher.png"],
    ["Icon-144.png", "mipmap-xxhdpi/ic_launcher.png"],
    ["Icon-192.png", "mipmap-xxxhdpi/ic_launcher.png"],
  ]

  file_map.each do |item|
    src = path(source_dir, item.first)
    dest = path(dest_dir, item.last)

    FileUtils.cp(src, dest, verbose: true)
  end
end


puts ARGV.inspect
if ARGV.count < 1
  puts help_message
else
  main
end


