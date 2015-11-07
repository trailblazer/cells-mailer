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

  def instance_subject
    "Hello #{name}!"
  end

  def instance_email
    email
  end
end

class MailerCellWithConfig < MailerCell
  mailer do
    to "nick@trailblazer.to"
    from "timo@schilling.io"
    subject "you are a cool!"
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

  it "allows using a instance method for the subject" do
    cell.deliver(options.merge(subject: :instance_subject))
    expect(mail.subject).to eq "Hello Nick!"
  end

  it "allows using a instance method for the to field" do
    cell.deliver(options.merge(to: :instance_email))
    expect(mail.to).to eq ["nick@trailblazer.to"]
  end

  it "allows using a instance method for the from field" do
    cell.deliver(options.merge(from: :instance_email))
    expect(mail.from).to eq ["nick@trailblazer.to"]
  end

  it "raise an argument error if option `:body` and `:method` is passed in" do
    expect {
      cell.deliver(options.merge(method: :a_method, body: "a body"))
    }.to raise_exception ArgumentError, "You can't pass in `:method` and `:body` at once!"
  end

  it "deliver options are optional" do
    mailer = double(deliver: true)
    expect(Mail).to receive(:new).with(kind_of(Hash)).and_return(mailer)
    cell.deliver
  end

  it "allows class level configurations" do
    expect(MailerCellWithConfig.to).to eq "nick@trailblazer.to"
    expect(MailerCellWithConfig.from).to eq "timo@schilling.io"
    expect(MailerCellWithConfig.subject).to eq "you are a cool!"
  end

  it "use class level settings" do
    MailerCellWithConfig.(nil).deliver
    expect(mail.to).to eq ["nick@trailblazer.to"]
    expect(mail.from).to eq ["timo@schilling.io"]
    expect(mail.subject).to eq "you are a cool!"
  end

  it "use class level settings only if no instance setting is present" do
    MailerCellWithConfig.(nil).deliver(to: "nick@apotomo.de")
    expect(mail.to).to eq ["nick@apotomo.de"]
    expect(mail.from).to eq ["timo@schilling.io"]
    expect(mail.subject).to eq "you are a cool!"
  end
end
