require 'struct_member'
require "acts_as_struct"
ActiveRecord::Base.send(:include, ::Nifty::Acts::Struct)
