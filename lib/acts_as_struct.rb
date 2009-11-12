# -*- coding: utf-8 -*-
module Nifty
  module Acts #:nodoc:
    module Struct #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_struct
          unless ancestors.include?(Nifty::Acts::Struct::InstanceMethods)
            has_many :struct_members, :as=>:struct, :dependent=>:destroy
            extend SingletonMethods
            include InstanceMethods
            after_save Callbacks.new
          end
        end
      end

      module SingletonMethods
        def struct_member(name, value_type, options={})
          name = name.to_s

          define_method(name + "=") do |value|
            dumped_value = Nifty::Acts::Struct.dump(value_type, value)
            if atr = struct_members.detect{|a| a.name == name }
              atr.value = dumped_value
            else
              struct_members.build(
                :name => name,
                :value_type => value_type.to_s,
                :value => dumped_value.to_s
              )
            end
          end

          define_method(name) do
            value = nil
            if atr = struct_members.detect{|a| a.name == name }
              value = atr.value
            elsif options.has_key?(:default)
              return options[:default]
            end
            Nifty::Acts::Struct.load(value_type, value)
          end

          if %w(boolean bool).include?(value_type.to_s)
            alias_method name + "?", name
          end
        end
      end

      module InstanceMethods
      end

      class Callbacks
        def after_save(record)
          record.struct_members.each(&:save!)
        end
      end

      class << self
        def dump(value_type, value)
          case value_type.to_s
          when "integer", "int"
            sprintf("%d", Integer(value)) rescue "0"
          when "float"
            sprintf("%e", Float(value)) rescue "0.0"
          when "boolean", "bool"
            value = value.to_s
            (value == "true" || value == "1") ? "true" : "false"
          when "text", "string", "binary"
            value.to_str rescue ""
          when "JSON"
            # NOTE: Rails2.3.4 のバグのため JSON.dump が使えない
            ActiveSupport::JSON.encode(value)
          else
            value_type.dump(value)
          end
        end

        def load(value_type, value)
          case value_type.to_s
          when "integer", "int"
            value ? Integer(value) : 0
          when "float"
            value ? Float(value) : 0.0
          when "boolean", "bool"
            (value == "true") ? true : false
          when "text", "string", "binary"
            value ? value.to_s : ""
          else
            value ? value_type.load(value) : nil
          end
        end
      end
    end
  end
end
