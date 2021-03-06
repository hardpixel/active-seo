# ActiveSeo

Optimize ActiveRecord models with support for SEO, Twitter and Open Graph meta.

[![Gem Version](https://badge.fury.io/rb/active_seo.svg)](https://badge.fury.io/rb/active_seo)
[![Build Status](https://travis-ci.org/hardpixel/active-seo.svg?branch=master)](https://travis-ci.org/hardpixel/active-seo)
[![Maintainability](https://api.codeclimate.com/v1/badges/4447eb1a073a93ace5b2/maintainability)](https://codeclimate.com/github/hardpixel/active-seo/maintainability)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_seo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_seo

Then run the generator that will create a migration for the SeoMetum model and an initializer:

    $ rails g active_seo:install

And finally run the migrations:

    $ rails db:migrate

## Usage

To add SEO meta support to an ActiveRecord model include the `ActiveSeo::Meta` Concern or use the `has_seo` class method:

```ruby
class Page < ApplicationRecord
  # Using concern
  include ActiveSeo::Meta

  # Or using `has_seo` class method
  has_seo
end
```

SeoMetum's attributes will be automatically delegated by your model with the `seo` prefix and you can use them in forms:

```erb
<%= form_for @page do |f| %>
  <%= f.text_field :seo_title %>
  <%= f.text_area  :seo_description %>
  <%= f.text_area  :seo_keywords %>
  <%= f.check_box  :seo_noindex %>
  <%= f.check_box  :seo_nofollow %>
<% end %>
```

To get a SEO attribute:

```ruby
@page.seo_title
```

To get all SEO attributes:

```ruby
@page.seo_meta
```

## Configuration

The install generator will create an initializer:

```ruby
ActiveSeo.setup do |config|
  # config.title_limit          = 70
  # config.description_limit    = 160
  # config.keywords_limit       = 255
  # config.keywords_separator   = ', '
  # config.title_fallback       = true
  # config.description_fallback = true
  # config.generate_keywords    = true

  # config.opengraph_setup do |og|
  #   og.type      = 'website'
  #   og.site_name = 'Site Name'
  # end

  # config.twitter_setup do |tw|
  #   tw.card    = 'summary'
  #   tw.site    = '@site'
  #   tw.creator = '@author'
  # end
end
```

You can set global defaults for attribute validations, automatic meta generation, OpenGraph and Twitter meta.

Settings `title_fallback` and `description_fallback` can be a `Symbol` or an `Array` of symbols that reference a model attribute/method which will be used to autogenerate the title and description attributes. When using an `Array` the first attribute that returns a value will be used.

This behavior can also be configured on a model level:

```ruby
class Page < ApplicationRecord
  # Using concern
  include ActiveSeo::Meta

  # With `seo_setup` method
  seo_setup title_fallback: :name, description_fallback: [:content, :excerpt]

  # Or using `has_seo` class method
  has_seo title_fallback: :name, description_fallback: [:content, :excerpt]
end
```

## OpenGraph and Twitter

If you want to define non-global OpenGraph and Twitter configurations you can create a custom meta contextualizer. ActiveSeo will look for a class defined in the model:

```ruby
class Page < ApplicationRecord
  # Using concern
  include ActiveSeo::Meta

  # With `seo_contextualizer` method
  seo_contextualizer 'CustomContextualizer'

  # Or using `has_seo` class method
  has_seo contextualizer: 'CustomContextualizer'
end
```

Or for a class located in `app/contextualizers` with a name like `ModelContextualizer`.

```ruby
class PageContextualizer < ActiveSeo::Contextualizer
  # Using a proc
  og_meta :image, -> obj { { _: obj.image, width: obj.image_width } }
  # Using a method defined in the contextualizer
  og_meta :video, :video_url

  # Using an attribute from the record
  twitter_meta :description, :seo_description
  # Using a string
  twitter_meta :card, 'app'

  # Use `record` to get record attributes
  def video_url
    record.video_url
  end
end
```

Inside the contextualizer you can define values using a `Proc` which gives you access to the record, a `Symbol` which will look for an attibute or method first inside the contextualizer and then in the model, or a `String` for a static value.

## Printing SEO meta

This gem does not provide helpers to output the meta, but was designed to provide a hash containing all the attributes the way the [Meta Tags](https://github.com/kpumuk/meta-tags) gem requires them.

So, if you're using Meta Tags you can do the following:

```erb
<%= display_meta_tags(@page.seo_meta) %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hardpixel/active-seo.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
