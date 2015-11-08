require "cells"
require "cell/mailer/version"
require "mail"

module Cell
  module Mailer
    def self.included(base)
      base.extend ClassMethods
    end

    def deliver(options = {})
      mail = Mail.new process_mail_options(options)
      mail.deliver
    end

    private

    def process_mail_options(options)
      if options[:body] && options[:method]
        raise ArgumentError, "You can't pass in `:method` and `:body` at once!"
      end

      [:to, :subject, :from].each do |field|
        options[field] = send(options[field]) if options[field].is_a? Symbol
      end

      [:to, :subject, :from].each do |field|
        options[field] ||= self.class.send(field)
      end

      (self.class.mail_options || {}).each do |key, value|
        options[key] = value
      end

      state = options.delete(:method) || :show
      options[:body] ||= call(state)

      options
    end

    module ClassMethods
      def self.extended(base)
        base.extend Uber::InheritableAttr
        base.inheritable_attr :to
        base.inheritable_attr :from
        base.inheritable_attr :subject
        base.inheritable_attr :mail_options
      end

      def mailer(&block)
        tap &block
      end

      def inheritable_attr(name, options={})
        super
        instance_eval %Q{
          def #{name}(value = :__undefined)
            return self.#{name} = value if value != :__undefined
            return @#{name} if instance_variable_defined?(:@#{name})
            @#{name} = Uber::InheritableAttribute.inherit_for(self, :#{name}, #{options})
          end
        }
      end
    end
  end
end
