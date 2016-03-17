# FriendlyId::Hstore

This gem provides and adapter to be able to manage localized slugs created with `friendly_id` when your project uses `hstore_translate` to store the translations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'friendly_id-hstore'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install friendly_id-hstore

## Usage

To use the gem, you just have to add it to install it (see the section above) and have `friendly_id` configured.

To specify that you are using `hstore_translate` to store the localized slug, you just have yo add `use: :hstore` to the `friendly_id` declaration inside your model:

```ruby
class MyModel < ActiveRecord::Base
  extend FriendlyId

  translates :title, :slug
  friendly_id :title, use: :hstore
end
```

**Note:** it's important to have the `slug` attribute (or the one you choose to store the friendly id) in the translations managed by `hstore_translate`. In case your field isn't localized, you can use the `:slugged` strategy instead and avoid this gem.

Also, remember that the slug field, as any other localized field with `hstore_translate`, should have it's `slug_translations` field in the database.

### Slug (re)generation

If you want to specify when your slug should be (re)generated, you can do it by overwriting the `should_generate_new_friendly_id?` function on your model:

```ruby
def should_generate_new_friendly_id?
  self.slug.blank?
end
```

## Tests

Tests haven't been created yet :(

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/simplelogica/friendly_id-hstore.
