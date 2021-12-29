# Toolcase

A module to convert a class in a Toolcase of handlers.

Inspired in an implementation of a Strategy pattern mixed with an Abstract Factory.
Add this module to a class to have the ability of register handlers as Strategies, and then search/select them as a Factory.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'toolcase'
```

And then execute:

    $ bundle install

## Usage

Extend a class to convert it into a strategy factory:

```ruby
class Factory
  extend Toolcase::Registry

  register Linux
  register Windows
  register MacOS
  register { |it| it.do_something }

  default InvalidOS
end
```

The `register` method adds an object to the registry. It can be a block or proc.

A default object can be assigned using the `default` method.
The default object, if present, will be returned by default in any search that no object is found.
This applies for the `find_by` and `[]` methods.

`register` methods has the following options:

```ruby
class Factory
  extend Toolcase::Registry

  register Linux, tag: :OS                # Registries can be classified with a tag.
  register OtherStuff, id: :otherstuff    # An item can have an identifier.
end
```

An object can be located in different ways:

```ruby
# By id.
Factory[:otherstuff]

# Using the find_by function, which will search through all registries.
Factory.find_by { |object| object.handle?(*args) }

# Search only through items with a specific tag.
Factory.find_by(:OS) { |object| object.handle?(*args) }

# Look up if an specific object belongs to the registry.
Factory.include?(object)

# Get all registries.
Factory.registries

# Get all tagged registries.
Factory.registries(:OS)
```

If another class inherits from the Factory, its registries are inherited too.
An useful use case is a validator registry, with common validators in base classes,
and specific validators in concrete classes.

```ruby
class BaseRegistry
  extend Toolcase::Registry

  register BaseValidator
  register NonEmpty
end

class SpecificRegistry < BaseRegistry
  register SpecificValidator
end

SpecificRegistry.size   # Returns 3.
```

An item can be replaced or removed using the item id or the item directly.

```ruby
Factory.replace(:linux, Ubuntu)
Factory.replace(Linux, Ubunut)
Factory.remove(:windows)
Factory.remove(Windows)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/enchf/toolcase.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
