![alt text](https://d21buns5ku92am.cloudfront.net/59399/images/195128-FL_Logo.4c_pos-9e9519-medium-1455014952.png "Logo Finleap GmbH")

# Cm-Sms

[![Build Status](https://img.shields.io/travis/HitFox/cm-sms.svg?style=flat-square)](https://travis-ci.org/HitFox/cm-sms)
[![Gem](https://img.shields.io/gem/dt/cm-sms.svg?style=flat-square)](https://rubygems.org/gems/cm-sms)
[![Code Climate](https://img.shields.io/codeclimate/github/HitFox/cm-sms.svg?style=flat-square)](https://codeclimate.com/github/HitFox/cm-sms)
[![Coverage](https://img.shields.io/coveralls/HitFox/cm-sms.svg?style=flat-square)](https://coveralls.io/github/HitFox/cm-sms)

## Description

Send text (SMS) messages via the HTTP API of [CM Telecom](https://www.cmtelecom.com) from your Ruby app.

For Rails integration, please see: https://github.com/HitFox/cm-sms-rails.
​
## Usage

Create a class that is inherited from `CmSms::Messenger`.

```ruby
class TextMessageNotifier < CmSms::Messenger
end
```

Now you can add methods to send messages. For example, send a `welcome` message with:

```ruby
class TextMessageNotifier < CmSms::Messenger
  default from: 'some string or mobile number'

  def welcome(recipient)
    @recipient = recipient
    
    content(to: recipient.mobile_number, body: 'Some text, reference: recipient.id)
  end
end
```

### Setting defaults

Use the public class method `default` to set default values that will be used in every method of your `CmSms::Messenger` subclass.
This method accepts a `Hash` as the parameter with possible keys `:from`, `:to` and `:body`. You may override these defaults inside
the methods themselves.

Example:

```ruby
class TextMessageNotifier < CmSms::Messenger
  default from: 'Quentin', '00491710000000'
  ...
end
```

### Deliver Messages

To send your SMS, call the desired method and then call `deliver_now` on the return value.

Calling the method returns a `CmSms::Message` object:

```ruby
message = TextMessageNotifier.new.welcome(User.first)   # => Returns a CmSms::Message object
message.deliver_now
```

### Optional Number Validation

Cm-Sms will look for the presence of either [Phony](https://github.com/floere/phony)
or [Phonelib](https://github.com/daddyz/phonelib) and use one of these libraries
to perform a basic check of receiver number. This check does not consider whether the
number is a mobile number.

## Installation

If you user bundler, then just add 
```ruby
$ gem 'cm-sms'
```
to your Gemfile and execute
```
$ bundle install
```
or without bundler
```
$ gem install cms-sms
```

### Upgrade

```
$ bundle update cms-sms
```

or without bundler

```
$ gem update cms-sms
```
​
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/HitFox/cm-sms. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
