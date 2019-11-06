#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'rack/utils'
require 'byebug'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'pp'
require 'httparty'
require 'fileutils'
require 'yaml'
require_relative 'uploader'

state_hash = JSON.parse(File.read('json-state/statefile.json'))
hub_api_token = YAML.load_file('json-state/secrets.yaml')['hub_api_token']
hub_base_url = YAML.load_file('json-state/config.yaml')['hub_base_url']

hub_api_token = ''
hub_base_url = 'https://api.datacite.org'
upload_compressed = false

# a special hack for the uploader class
ENV['TOKEN'] = hub_api_token


filenames = Dir.glob('json-reports/*.json').sort

filenames.each do |fn|
  puts "Starting #{fn}"
  month_key = fn.match(/\d{4}-\d{2}/).to_s
  month_info = state_hash[month_key]

  if upload_compressed
    uploader = Uploader.new(report_id: month_info['id'], file_name: fn)
    report_id = uploader.process
    puts "reported id #{report_id}"
  else
    response = HTTParty.put("#{hub_base_url}/reports/#{month_info['id']}",
                            body: File.open(fn, 'r').read,
                            headers: {
                                'Content-Type' => 'application/json',
                                'Accept' => 'application/json',
                                'Authorization' => "Bearer #{hub_api_token}" },
                            timeout: 300)
    # response.headers are useful
    # response.code should be 200
    puts response.headers
    puts response.code
  end

  puts "Finished #{fn}\r\n\r\n"
end

