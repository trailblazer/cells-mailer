require 'spec_helper'

class MailerCell < Cell::ViewModel
  include Cell::Mailer

  def show
    "body"
  end
end

RSpec.describe Cell::Mailer do
  subject(:cell) { MailerCell.(nil) }

  let(:options) { { from: "foo@example.org", to: "bar@example.org", subject: "example" } }

  it "delivers a Mail" do
    cell.deliver(options)
    expect(Mail::TestMailer.deliveries.count).to eq 1
    mail = Mail::TestMailer.deliveries.first
    expect(mail.from).to eq ["foo@example.org"]
    expect(mail.to).to eq ["bar@example.org"]
    expect(mail.subject).to eq "example"
    expect(mail.body.raw_source).to eq "body"
  end
end
