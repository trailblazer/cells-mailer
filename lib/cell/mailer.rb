require "cells"
require "cell/mailer/version"
require "mail"

module Cell
  module Mailer
    def deliver(options)
      state = options.delete(:method) || :show
      options[:body] = call(state)
      mail = Mail.new options
      mail.deliver
    end
  end
end
