#!/usr/bin/env ruby
# encoding: UTF-8

require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'optparse'


def get_wordpress_version(url)
  doc = Nokogiri::HTML(open(url))
  doc.xpath("//meta[@name='generator']/@content").each do |attr|
    puts attr.value
  end
end

def xmlrpc_protocol_enabled?(url)
  url = URI.parse(url+'/xmlrpc.php')
  req = Net::HTTP.new(url.host, url.port)
  res = req.request_head(url.path)
  msg = "XML-RPC protocol for #{url} disabled"
  
  if res.code == "405"
    msg =  "XML-RPC protocol on #{url} enabled"
  end
  msg
end

def enumerate_users(url, cnt)
  users = []
  for i in 0..cnt
    url = URI.parse(url)
    req = Net::HTTP.new(url.host, url.port)
    res = req.request_head(url.path)
    puts res.code
    if res.code == "301"
     users << i
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

options = {:url => 'http://127.0.0.1:8080', :wp_version => true, :xmlrpc => true, :enumarate => true, :enumeration_number => 3}

OptionParser.new do |opts|
  opts.banner = "Usage: wp_info_gathering.rb [options]"
  opts.on('--url url', 'Url, default: http://127.0.0.1') do |url|
    options[:url] = url
  end
  
  opts.on('-w', '--wp-version', 'Display wordpress version') do |version|
    options[:version] = true
  end

  opts.on('-x', '--xmlrpc', 'Check if XML-RPC API enabled') do |enabled|
    options[:version] = true
  end

  opts.on('-e', '--enumarate', 'Enumerate users') do |version|
    options[:version] = true
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end.parse!

wp_info_gathering(options)

