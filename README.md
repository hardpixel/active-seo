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

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install active_seo
```

Then run the generator that will create a migration for the SeoMetum model and an initializer:

```console
$ rails g active_seo:install
```

And finally run the migrations:

```console
$ rails db:migrate
```

## Usage

To add SEO meta support to an ActiveRecord model include the `ActiveSeo::Meta` Concern:

```ruby
class Page < ApplicationRecord
  include ActiveSeo::Meta
end
```

This way SeoMetum's attributes will be automatically delegated by your model with the `seo` prefix.

E.g. in your the form:

```erb
<%= form_for @page do |f| %>
  <%= f.text_field :seo_title %>
  <%= f.text_area :seo_description %>
  <%= f.text_area :seo_keywords %>
  <%= f.check_box :seo_noindex %>
  <%= f.check_box :seo_nofollow %>
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

The install generator will create an initializer, which contains the following:

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

Settings `title_fallback` and `description_fallback` can also accept either a `Symbol` which could be another model attribute or method, or an `Array` of attributes/methods to grab values from in order to autogenerate the title and description attributes.

This behavior can also be configured on a model level, so in your Page model you could do something like this:

```ruby
class Page < ApplicationRecord
  include ActiveSeo::Meta

  # Set SEO config
  seo_setup title_fallback: :name, description_fallback: [:content, :excerpt]
end
```

## OpenGraph and Twitter meta

If you want to define non-global OpenGraph and Twitter configurations you can create a custom meta contextualizer.

ActiveSeo will look for a class defined in the model e.g.:

```ruby
class Page < ApplicationRecord
  include ActiveSeo::Meta

  # Set meta contextualizer
  seo_contextualizer 'CustomContextualizer'
end
```

or for a class located at `app/contextualizers` with a name like `PageContextualizer`.

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

#### Notes

Inside the contextualizer you can define values using a `Proc` which gives you access to the record, a `Symbol` which will look for an attibute or method first inside the contextualizer and then in the model, or a `String` for a static value.

## Printing SEO meta

This gem does not provide helpers to output the meta, but was designed to provide a hash containing all the attributes the way the [Meta Tags](https://github.com/kpumuk/meta-tags) gem requires them.

So, if you're using Meta Tags you can do the following:

```erb
<%= display_meta_tags(@page.seo_meta) %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hardpixel/active-seo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveSeo project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hardpixel/active-seo/blob/master/CODE_OF_CONDUCT.md).
