# Cells::Mailer

Provides mail functionality for [Cells](https://github.com/apotonick/cells/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cells-mailer'
```

And then execute:

    $ bundle

## Configuration

Cells::Mailer don't provide any own configuration at the moment. 
Please take a look at the [mail](https://github.com/mikel/mail) gem for any configuration options.

## Usage

```ruby
class UserNotificationCell < Cell::ViewModel
  include Cell::Mailer
  property :user_name

  def show
    "Hello #{user_name}"
  end
end

UserNotificationCell.(user).deliver(from: "foo@example.com", to: user.email, subject: "Hello")
```

### Body

Equal to Cells, you can deliver (render) different states of your Cell:

```ruby
class UserNotificationCell < Cell::ViewModel
  include Cell::Mailer
  property :user_name

  def welcome
    "Hello #{user_name}"
  end
end

UserNotificationCell.(user).deliver(..., method: :welcome)
```

I don't know why you should use it, but you can also pass in a body as argument.

```ruby
UserNotificationCell.(user).deliver(..., body: "Hello user")
```

## Roadmap

- Allow instand methods as source for
  - `from`
  - `to`
  - `subject`
- Allow class level configurations for
  - `from`
- Provide class level `mail` delivery configurations
