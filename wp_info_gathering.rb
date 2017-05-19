#!/usr/bin/env ruby
# encoding: UTF-8

require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'optparse'
require 'open-uri'


def get_wordpress_version(url)
  doc = Nokogiri::HTML(open(url).read)
  doc.xpath("//meta[@name='generator']/@content").each do |attr|
    puts attr.value
  end
end

def xmlrpc_protocol_enabled?(url)
  uri = URI(url + '/xmlrpc.php')
  response = Net::HTTP.get(uri)
  
  puts "\n#{response}\n"
end

def enumerate_users(url, cnt)
  for i in 1..cnt.to_i do
    uri = URI(url + "/?author=#{i}")
    response = Net::HTTP.get_response(uri)
    hash_response = response.to_hash

    if response.code == '301'
      puts "\nUsername: #{hash_response['location'].first.split('/').last} for author=#{i}\n"
    end
  end
end

def wp_info_gathering(options)
  url = options[:url]
  
  if options[:wp_version] == true
    get_wordpress_version(url)
  end
  
  if options[:xmlrpc] == true
    xmlrpc_protocol_enabled?(url)
  end

  if options[:enumarate] == true
    enumerate_users(url, options[:enumeration_number])
  end
end

options = {:url => 'http://127.0.0.1:8080/wordpress', :wp_version => false, :xmlrpc => false, :enumarate => false, :enumeration_number => '3'}

OptionParser.new do |opts|
  opts.banner = "Usage: wp_info_gathering.rb [options]"

  opts.on('-u', '--url url', 'Url, default: http://127.0.0.1') do |url|
    options[:url] = url
  end

  opts.on('-w', '--wp-version', 'Display wordpress version')   { options[:wp_version] = true }
  opts.on('-x', '--xmlrpc', 'Check if XML-RPC API enabled')    { options[:xmlrpc]     = true }
  opts.on('-e', '--enumarate', 'Enumerate users')              { options[:enumarate]  = true }
  
  opts.on('-n', '--enumaration_number enumaration_number', 'Max enumeration number, default is 3') do |enumaration_number|
    options[:enumeration_number] = enumaration_number
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end.parse!

wp_info_gathering(options)

