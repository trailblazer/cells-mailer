require "cells"
require "cell/mailer/version"
require "mail"

module Cell
  module Mailer
    def deliver(options)
      state = options.delete(:method) || :show
      mail = Mail.new options
      mail.body call(state)
      mail.deliver
    end
  end
end
