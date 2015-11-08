require 'spec_helper'

RSpec.describe Cell::Mailer::Configuration do
  it "stores configurations" do
    config = Cell::Mailer::Configuration.new
    config.to = "to"
    config.from = "from"
    config.subject = "subject"
    config.mail_options = "mail_options"
    expect(config.to).to eq "to"
    expect(config.from).to eq "from"
    expect(config.subject).to eq "subject"
    expect(config.mail_options).to eq "mail_options"
  end

  it "has default values" do
    config = Cell::Mailer::Configuration.new
    expect(config.to).to eq nil
    expect(config.from).to eq nil
    expect(config.subject).to eq nil
    expect(config.mail_options).to eq({})
  end

  it "initialized with args" do
    config = Cell::Mailer::Configuration.new(to: :to, from: :from, subject: :subject, mail_options: :mail_options)
    expect(config.to).to eq :to
    expect(config.from).to eq :from
    expect(config.subject).to eq :subject
    expect(config.mail_options).to eq :mail_options
  end

  it "allows initialize only with configured args" do
    expect {
      Cell::Mailer::Configuration.new(foo: :bar)
    }.to raise_exception ArgumentError, "`:foo` is not a valid argument!"
  end

  it "can be cloned" do
    config = Cell::Mailer::Configuration.new(to: "to")
    new_config = config.clone
    expect(config.to).to eq new_config.to
    expect(config.to).to_not be new_config.to
  end
end
