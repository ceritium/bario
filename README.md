# Bario

[![codecov](https://codecov.io/gh/ceritium/bario/branch/master/graph/badge.svg)](https://codecov.io/gh/ceritium/bario)
[![Gem Version](https://badge.fury.io/rb/bario.svg)](https://badge.fury.io/rb/bario)

Bario means [Barium](https://en.wikipedia.org/wiki/Barium) in spanish.

![Barium](https://upload.wikimedia.org/wikipedia/commons/1/16/Barium_unter_Argon_Schutzgas_Atmosph%C3%A4re.jpg)

This gem aim to provide a simple interface to track the progress of your process like background jobs, scripts, cron jobs... with a kind progress bars backed by redis.


This gem still in very early state of development. Some behaviour could change in the future. 
Ideas, pull requests and any kind of feedback are welcome.

## Install

```bash
$ gem install bario
```

or add it to the Gemfile
```ruby
gem "bario"
```


## Usage

Examples:

```ruby
# Create a bar with 100 as total
b1 = Bario::Bar.create(total: 100)

# Increment a unit
b1.increment

# Increment 10 units
b1.increment(10)

# Decrement 
b1.decrement

# Create a nested bar
b2 = b1.add_bar(total: 10)
b2.increment

# Find a bar
b3 = Bario::Bar.find(b1.id)

# List all bars
Bario::Bar.all

# Delete a bar (and nested bars)
b3.delete

# You can also name a bar, usefull to identify it in the web panel.
foo = Bario::Bar.create(name: "foo")

# Attributes of a bar
foo.inspect #=> 
#<Bario::Bar:70234519614100 id: 12, name: foo, total: 100, current: 0, root: true, created_at: 2017-11-26 21:29:30 UTC, updated_at: 2017-11-26 21:29:30 UTC>
```

## The frontend

![screen shot 2017-11-23 at 23 45 39](https://user-images.githubusercontent.com/16633/33189997-8c95d226-d0a8-11e7-8a62-288e50e73ae8.png)

### Standalone

If you've installed Bario as a gem running the front end standalone is easy:

```bash
$ bario-web start
```

```bash
$ bario-web --redis redis://localhost:6379/0 start
```

For more options check the help:
```bash
$ bario-web --help
```

### Rails 3 onwards

You can also mount Bario on a subpath in your existing Rails app by adding `require "bario/web"` to the top of your routes file or in an initializer then adding this to routes.rb:

```ruby
mount Bario::Web => "/bario"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ceritium/bario. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bario project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ceritium/bario/blob/master/CODE_OF_CONDUCT.md).
