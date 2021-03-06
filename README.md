# Rasti::Web::ApiDoc

Generate documentation of endpoint usage based on tests.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rasti-web-api_doc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rasti-web-api_doc

## Usage

Add following task in your Rakefile

```ruby
require 'rasti/web/api_doc'

Rasti::Web::ApiDoc::Task.new(:doc) do |t|
  t.env = './environment.rb'
  t.app = 'MyApp::Web'
  t.path = 'spec' # Optional
  t.pattern = 'spec/**/*_spec.rb' # Optional
  t.output = 'API.md' # Optional
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gabynaiman/rasti-web-api_doc.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

