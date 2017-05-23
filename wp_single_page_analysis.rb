#!/usr/bin/env ruby
# encoding: UTF-8

require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'optparse'

def wp_single_page_analysis(options)
  doc = Nokogiri::HTML(open(options[:url]).read)
  
  # wordpress version discovery
  doc.xpath("//meta[@name='generator']/@content").each do |attr|
    puts "\nWordPress version from meta tag named 'generator' is: #{attr.value}\n"
  end
  
  # XML-RPC location discovery
  doc.xpath("//link[@rel='pingback']/@href").each do |attr|
    puts "\nWordPress XML-RPC location from link tag with rel='pingback' is: #{attr.value}\n"
  end
  
  # XML-RPC location discovery
  doc.xpath("//link[@rel='EditURI']/@href").each do |attr|
    puts "\nWordPress XML-RPC location from link tag with rel='EditURI' is: #{attr.value}\n"
  end
  
  # REST API discovery
  doc.xpath("//link[@rel='https://api.w.org/']/@href").each do |attr|
    puts "\nWordPress REST API discovery(enabled/disabled) from link tag with rel='https://api.w.org/' is: #{attr.value}\n"
  end

  all_links = doc.xpath('//@href | //@src').map(&:value)
  
  print_discovered_plugins(all_links)
  print_discovered_themes(all_links)
end

def print_discovered_plugins(links)
  plugin_links = links.find_all{|l| l.include?('/wp-content/plugins/')}

  plugins = []
  plugin_links.each do |link|
    link_parts = link.split('/')
    plugins << link_parts[link_parts.index('plugins') + 1]
  end

  puts "\n\nDISCOVERED PLUGINS:\n"
  plugins.uniq.each do |p|
    puts "Plugin name: #{p}\n"
  end
end

def print_discovered_themes(links)
  theme_links = links.find_all{|l| l.include?('/wp-content/themes/')}

  themes = []
  theme_links.each do |link|
    link_parts = link.split('/')
    themes << link_parts[link_parts.index('themes') + 1]
  end

  puts "\n\nDISCOVERED THEMES:\n"
  themes.uniq.each do |t|
    puts "Theme name: #{t}\n"
  end
end

options = {:url => 'http://127.0.0.1:8080'}

OptionParser.new do |opts|
  opts.banner = "Usage: wp_single_page_analysis.rb [options]"

  opts.on('-u','--url url', 'Url, default: http://127.0.0.1:8080') do |url|
    options[:url] = url
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end.parse!

wp_single_page_analysis(options)