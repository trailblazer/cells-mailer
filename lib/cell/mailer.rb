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
      options[:body] ||= call(state)
      options
    end
  end
end
