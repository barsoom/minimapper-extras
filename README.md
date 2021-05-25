[![Build Status](https://secure.travis-ci.org/barsoom/minimapper-extras.svg)](http://travis-ci.org/barsoom/minimapper-extras)
[![Maintainability](https://api.codeclimate.com/v1/badges/d7d9437801178ad0570b/maintainability)](https://codeclimate.com/github/barsoom/minimapper-extras/maintainability)

# Minimapper::Extras

Extra tools for [minimapper](https://github.com/joakimk/minimapper).

## Installation

Add this line to your application's Gemfile:

    gem 'minimapper-extras'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minimapper-extras

## Usage

For now, see the specs. TODO: Write docs.

## Conversions

Additional attribute conversions. See [lib/minimapper/entity/conversions.rb](https://github.com/barsoom/minimapper-extras/blob/master/lib/minimapper/entity/conversions.rb) for a full list.

```ruby
require "minimapper/entity/conversions"

class User
  include Minimapper::Entity

  attribute :registered_on, :date
  attribute :other
end

user = User.new
user.registered_on = "2001-01-01"
user.registered_on # => Mon, 01 Jan 2001

user.other = "2001-01-01"
user.other # => "2001-01-01"
```

## Custom FactoryGirl strategy

Add this to your spec_helper after loading FactoryGirl:

```ruby
require "minimapper/factory_girl"
```

It changes the create strategy used by FactoryGirl to make it compatible with minimapper.

So far it only supports saving single entities and belongs_to associations.

It assumes you can access your mappers though something like "Repository.employees". You can override that by
changing `CreateThroughRepositoryStrategy::Create#mapper_with_name`.

It also assumes the model has accessors for related objects, we use the "minimapper/entity/belongs_to" to do this.

Example factory definition:

```ruby
require "customer"

FactoryGirl.define do
  factory :order do
    customer { FactoryGirl.build(:customer) }
    description "ref. 123"
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
