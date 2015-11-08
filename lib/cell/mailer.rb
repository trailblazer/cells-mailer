require "cells"
require "cell/mailer/configuration"
require "cell/mailer/version"
require "mail"

module Cell
  module Mailer
    def self.included(base)
      base.extend ClassMethods
    end

    def self.configure(&block)
      configuration.instance_eval &block
    end

    def self.configuration
      @configuration ||= Cell::Mailer::Configuration.new
    end

    def self.clear_configuration!
      @configuration = nil
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
        options[field] ||= self.class.mailer.send(field)
      end

      (self.class.mailer.mail_options || {}).each do |key, value|
        options[key] = value
      end

      state = options.delete(:method) || :show
      options[:body] ||= call(state)

      options
    end

    module ClassMethods
      def mailer(&block)
        mailer_configuration.instance_eval &block if block
        mailer_configuration
      end

      private

      def mailer_configuration
        @mailer_configuration ||= Cell::Mailer.configuration.clone
      end

      def inherited(child)
        child.instance_variable_set(:@mailer_configuration, mailer_configuration.clone)
      end
    end
  end
end
