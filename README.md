# Wisper::Testing

Helpers for testing Wisper publisher/subscribers.

## Installation

```ruby
gem 'wisper-testing'
```

## Usage

Using `fake!` and `fake` prevents any events from being broadcast. 

Instead each event is recorded and can be inspected.

```ruby
Wisper::Testing.fake!

Wisper::Testing.fake do
  # ...
end

Wisper::Testing.events # => [...]
```

### Inline

Using `inline!` and `inline` ensures all events are broadcast using the default
broadcaster, meaning any subscribers which are subscribed with `async: true`
will not be called asynchronously, but synchronously.

```ruby
Wisper::Testing.inline!

Wisper::Testing.inline do
  # ...
end
```

### Restore

Using `restore!` will turn off `fake!` and `inline!`. It is not nessesary to
call this if you are using the block variations `fake` and `inline`.

```ruby
Wisper::Testing.restore!
```

## Development

```
ls **/*.rb | entr -c bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/krisleech/wisper-testing.

This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org)
code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

