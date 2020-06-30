#! /usr/bin/env ruby

require 'fileutils'

def path(base, name)
  File.expand_path(File.join(base, name))
end

def help_message
  "Usage: ios_images.rb SOURCE_DIR DESTINATION_DIR\nWhere SOURCE_DIR looks like: PROJECT/appiconmaker/iOS\nWhere DESTINATION_DIR looks like: PROJECT/Assets.xcassets"
end

def main
  source_dir = ARGV.first
  dest_dir = ARGV.last

  file_map = [
    16,
    20,
    29,
    32,
    40,
    48,
    50,
    55,
    57,
    58,
    60,
    64,
    72,
    76,
    80,
    87,
    88,
    100,
    114,
    120,
    128,
    144,
    152,
    167,
    172,
    180,
    196,
    256,
    512,
    1024
  ]

  file_map.each do |item|
    filename = "Icon-#{item}.png"
    src = path(source_dir, filename)
    dest = path(dest_dir, "AppIcon.appiconset/#{filename}")

    FileUtils.cp(src, dest, verbose: true)
  end
  FileUtils.cp("../bristlecone/ios/Contents-AppIcon.json", path(dest_dir, "AppIcon.appiconset/Contents.json"))
  FileUtils.cp(path(source_dir, "Icon-1024.png"), path(dest_dir, "LaunchLogo.imageset/Icon-1024.png"))
  FileUtils.cp("../bristlecone/ios/Contents-LaunchLogo.json", path(dest_dir, "LaunchLogo.imageset/Contents.json"))
  FileUtils.cp(path(source_dir, "Icon-1024.png"), path(dest_dir, "SidebarIcon.imageset/Icon-1024.png"))
  FileUtils.cp("../bristlecone/ios/Contents-SidebarIcon.json", path(dest_dir, "SidebarIcon.imageset/Contents.json"))
end

puts ARGV.inspect
if ARGV.count < 1
  puts help_message
else
  main
end


