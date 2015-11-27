![alt text](http://www.hitfoxgroup.com/downloads/hitfox_logo_with_tag_two_colors_WEB.png "Logo Hitfox Group")


Cm::Sms
=======

[![Build Status](https://img.shields.io/travis/HitFox/cm-sms.svg?style=flat-square)](https://travis-ci.org/HitFox/cm-sms)
[![Gem](https://img.shields.io/gem/dt/cm-sms.svg?style=flat-square)](https://rubygems.org/gems/cm-sms)
[![Code Climate](https://img.shields.io/codeclimate/github/HitFox/cm-sms.svg?style=flat-square)](https://codeclimate.com/github/HitFox/cm-sms)
[![Coverage](https://img.shields.io/coveralls/HitFox/cm-sms.svg?style=flat-square)](https://coveralls.io/github/HitFox/cm-sms)

Description
-----------

Send text messages by means of the HTTP protocol with the service of https://www.cmtelecom.com, from your ruby app.
If you want to send sms from your rails app, please have a look at: https://github.com/HitFox/cm-sms-rails.
​
Usage
------------

Create a class that is inherited from `CmSms::Messenger`.

```ruby
class TextMessageNotifier < CmSms::Messenger
end
```

Now you can add your first welcome message.
This can be as simple as:

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

It is possible to set default values that will be used in every method in your CmSms Messenger class. To implement this functionality, you just call the public class method default which is inherited from CmSms::Messenger. This method accepts a Hash as the parameter. You can use :from, :to and :body as the key.

Note that every value you set with this method will get overwritten if you use the same key in your mailer method.

Example:

```ruby
class TextMessageNotifier < CmSms::Messenger
  default from: "Quentin", "00491710000000"
  .....
end
```
### Deliver messages

In order to send your sms, you simply call the method and then call `deliver_now` on the return value.

Calling the method returns a CmSms Message object:
```ruby
message = TextMessageNotifier.welcome(User.first)   # => Returns a CmSms::Message object
message.deliver_now
```

Installation
------------

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

Upgrade
-------
```
$ bundle update cms-sms
```
or without bundler

```
$ gem update cms-sms
```
​
Changelog
---------

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/HitFox/cm-sms. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
