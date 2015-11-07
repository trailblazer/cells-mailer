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
      options[:to] = send(options[:to]) if options[:to].is_a? Symbol
      options[:from] = send(options[:from]) if options[:from].is_a? Symbol
      options[:subject] = send(options[:subject]) if options[:subject].is_a? Symbol
      options[:body] ||= call(state)
      options
    end
  end
end
