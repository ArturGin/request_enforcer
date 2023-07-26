# RequestEnforcer

Enforce your API calls to use provided modules.

Here is the setup:
Projected is developed by several generations of programmers who like to do things in their way. One of those things is interactions with APIs

It is going great, so what if calls to external APIs are going through 3 different places? 
The problem starts when this external API starts to change and starts introducing breaking changes. Then we need to refactor, but our API call logic is spread out across several modules and it is not obvious did you find all of them

That's the problem this gem is trying to solve. By specifying objects that are used for calling an API we can have a more sustainable code base

## Installation

Add this line to your application's Gemfile:

```ruby
gem "request_enforcer", git: 'https://github.com/ArturGin/request_enforcer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install request_enforcer

## Usage

This gem is written with Rails way in mind. If there is need for other web frameworks - shoot a PR!

Add this example config in some file in `config/initializers/` 
``` ruby
if Rails.env.development? || Rails.env.test?
	RequestEnforcer.config do |c|
		c.enforce 'httpbingo.org', to_use: SomeClass
		c.warning_level = :error
		c.silence_console_requests = false
	end
end
```

`enforce` a host `to_use:` object
> to_use accepts an array of Objects

`warning_level` can be `:error`  or `:warning` 
- Error raises an error
- Warning writes to console

`silence_console_requests` is boolean and silences error or warning if request is coming from console

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ArturGin/request_enforcer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).