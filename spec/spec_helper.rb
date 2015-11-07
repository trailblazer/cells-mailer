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

  # These three settings work together to allow you to limit a spec run to
  # individual examples or groups you care about by tagging them with
  # `:focus` or `:skip` metadata. When nothing is tagged with `:focus`,
  # all examples get run.
  config.filter_run_including :focus
  config.filter_run_excluding :skip
  config.run_all_when_everything_filtered = true

  config.expose_dsl_globally = false
end
