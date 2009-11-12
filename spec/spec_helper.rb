# -*- coding: utf-8 -*-

plugin_spec_dir = File.dirname(__FILE__)

$:.unshift File.join(plugin_spec_dir, '..', 'lib')

require 'rubygems'
require 'activerecord'
require 'spec'

ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

database = YAML.load(File.read(plugin_spec_dir + '/db/database.yml'))
ActiveRecord::Base.establish_connection(database[ENV['DB'] || 'sqlite3'])
load File.join(plugin_spec_dir, 'db', 'schema.rb')

require File.join(plugin_spec_dir, '..', 'rails', 'init')
