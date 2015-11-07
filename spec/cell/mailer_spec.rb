require 'spec_helper'

class MailerCell < Cell::ViewModel
  include Cell::Mailer
  property :name
  property :email

  def show
    "body"
  end

  def different_body
    "a different body"
  end
end

RSpec.describe Cell::Mailer do
  subject(:cell) { MailerCell.(user) }
  subject(:mail) { Mail::TestMailer.deliveries.first }

  let(:options) { { from: "foo@example.org", to: "bar@example.org", subject: "example" } }
  let(:user) { OpenStruct.new email: "nick@trailblazer.to", name: "Nick" }

  it "delivers a Mail" do
    cell.deliver(options)
    expect(Mail::TestMailer.deliveries.count).to eq 1
    expect(mail.from).to eq ["foo@example.org"]
    expect(mail.to).to eq ["bar@example.org"]
    expect(mail.subject).to eq "example"
    expect(mail.body.raw_source).to eq "body"
  end

  it "allows passing in a body string" do
    cell.deliver(options.merge(body: "custom body"))
    expect(mail.body.raw_source).to eq "custom body"
  end

  it "allows a different body method" do
    cell.deliver(options.merge(method: :different_body))
    expect(mail.body.raw_source).to eq "a different body"
  end
end
