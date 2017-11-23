# Bario

[![Coverage Status](https://coveralls.io/repos/github/ceritium/bario/badge.svg?branch=master)](https://coveralls.io/github/ceritium/bario?branch=master)

Bario means [Barium](https://en.wikipedia.org/wiki/Barium) in spanish.

![Barium](https://upload.wikimedia.org/wikipedia/commons/1/16/Barium_unter_Argon_Schutzgas_Atmosph%C3%A4re.jpg)

This gem aim to provide a simple interface to track the progress of your process like background jobs, scripts, cron jobs... with a kind progress bars backed by redis.

**Work in progress**

TODO: Explain a little bit more.

## Usage

Examples:

```ruby
t1 = Bario::Track.create("foo", total: 100)
t1.increment!
t1.increment!(10)

t1a = t1.add_track("foobar", total: 10)
t1a.increment!

t1.delete!

Bario::Track.all
```

TODO: Proper usage documentation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ceritium/bario. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bario project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ceritium/bario/blob/master/CODE_OF_CONDUCT.md).
