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
      state = options.delete(:method) || :show
      [:to, :subject, :from].each do |field|
        options[field] = send(options[field]) if options[field].is_a? Symbol
      end
      options[:body] ||= call(state)
      options
    end
  end
end
