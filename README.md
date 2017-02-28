# Fossicker

`fossick` is a `fetch`-like version of Ruby's `dig`. It supports defaults and will raise an exception if 
it finds a missing key or index (unless you supply a default).  

## Installation

Add this line to your application's Gemfile:

```ruby
gem "fossicker"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fossicker

## Usage

Use the `Fossicker` refinement to add `fossick` to `Array` and `Hash`.

```ruby
using Fossicker

# Basic use

{ a: { b: "paydirt" } }.fossick :a, :b 
# => "paydirt"


# Fossick through arrays and hashes

[ "nothing here", { a: [ { b: "paydirt" } ] } ].fossick 1, :a, 0, :b
# => "paydirt"


# Missing key or index

{ a: [ { b: "paydirt" } ] }.fossick :a, 1, :b
# => IndexError: index 1 outside of array bounds: -1...1


# Supplying a default value

{ a: [ { b: "paydirt" } ] }.fossick :a, 1, :b, default: "zilch"
# => "zilch"


# Using a block for the default value

{ a: [ { b: "paydirt" } ] }.fossick :a, 0, :c do |key| 
  "Nothing for #{key.inspect}"
end
# => "Nothing for :c"


# Emulating `dig`

{ a: [ "paydirt" ] }.fossick :a, 0, default: nil
# => nil
```

If you don't want to use refinements, or can't because of Ruby's refinement scoping quirks, you can use the
module method directly.

```ruby
object = { a: { b: "paydirt" } }
Fossicker.fossick object, :a, :b 
# => "paydirt"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the 
tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, 
update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git 
tag for the version, push git commits and tags, and push the `.gem` file to 
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/johncarney/fossicker. This 
project is intended to be a safe, welcoming space for collaboration, and contributors are expected to 
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

