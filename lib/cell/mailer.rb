require "cells"
require "cell/mailer/version"
require "mail"

module Cell
  module Mailer
    def deliver(options)
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

      state = options.delete(:method) || :show
      options[:body] ||= call(state)

      options
    end
  end
end
