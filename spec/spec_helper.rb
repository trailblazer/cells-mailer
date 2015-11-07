$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'cell/mailer'

RSpec.configure do |config|
  config.before(:suite) do
    Mail.defaults do
      delivery_method :test
    end
  end

  config.after(:each) do
    Mail::TestMailer.deliveries.clear
  end
end
