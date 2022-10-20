# Pipedrive API Ruby library

Pipedrive::Connect provides a convenient access to the Pipedrive API from applications written in the Ruby language.

It abstracts the developer from having to deal with API requests by mapping the list of the core resources like Organization, Person or Deal to ruby classes and objects.

Key features:

- Easy to setup.
- Map core concepts in Pipedrive to ruby classes.
- Allow access to relationships among these concepts like accessing all the persons within an organization or its deals.
- Abstract the developer from having to deal with custom fields by doing it internally.

## Documentation

Check the original API doc at: https://pipedrive.readme.io/

## Installation

Add this line to your application's Gemfile:

```ruby
gem "pipedrive-connect", github: "getonbrd/pipedrive-connect"
```

then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install pipedrive-connect
```

## Usage

Configure the library by initializing it with the **api key** you can find in your [setttings page at Pipedrive](https://yourcompany.pipedrive.com/settings/api).

```ruby
Pipedrive.api_key = "abc123"
```

In case of using rails, do it via an initalizer:

```ruby
# file: app/initializers/pipedrive.rb

require 'pipedrive'

Pipedrive.api_key = ENV["PIPEDRIVE_API_KEY"]
```

### Models

Access your data in pipedrive via the models (for the complete list check out the directory `lib/pipedrive/resources`). You'll find that most of these classes are documented in the [API Reference](https://developers.pipedrive.com/docs/api/v1/).

For example to search, retrieve, access, create, update or delete an organization:

```ruby
# search for organizations with the term "Acme Inc" in any of their fields
# return an array of Pipedrive::Organization instances
orgs = Pipedrive::Organization.search("Acme Inc")

# specify it is an exact match and reduce the scope to name and address
orgs = Pipedrive::Organization.search(
  "Acme Inc",
  extact_match: true,
  fields: [:name, :address]
)

# Want to paginate across all the organizations sorting them by name?
orgs = Pipedrive::Organization.all(
  "Acme Inc",
  start: 0,
  limit: 100,
  sort: :name
)

# if you know the id then retrieve the org
acme = Pipedrive::Organization.retrieve(123)
acme.name

# get access to the activities, deals and persons of the org
acme.activities
acme.deals
acme.persons

# create a new one
new_branch = Pipedrive::Organization.create(name: "New Acme Inc")
# update the name
new_acme.update(name: "Acme the new Inc")

# ot simply delete it
new_acme.delete
```

### 204 No Content responses

Some endpoints of the API return the HTTP status code **204** which is still a success code returning no data (empty body). This could be confusing but probably has a rationale behind.

For these cases a method `empty?` within the model responds `true`.

For instance:

```ruby
# Asuming the subscription is not found but still return with empty body
subscription = Pipedrive::Subscription.find_by_deal(123)
subscription.empty? # true
subscription.no_content? # true - is an alias of empty?
```

In case you want to override that behavior treating **no content** as **not found**, there is an option for that:

```ruby
Pipedrive.treat_no_content_as_not_found = true
# Will raise a instance of Pipedrive::NotFoundError if subscription
subscription = Pipedrive::Subscription.find_by_deal(123)
```

### Custom Fields

Pipedrive gives you the chance to add additional data by creating custom fields that are not included by default. Deals, Persons, Organizations and Products can all contain custom fields.

[See the doc here](https://pipedrive.readme.io/docs/core-api-concepts-custom-fields).

The issue with accessing a custom field via the API is that you have to know the assigned key, for instance, let's say we added a custom field called `domain` of type _text_ to the `Organization` in Pipedrive. If we would want to add a new organization using the API, this "would" be the code:

```ruby
org = Pipedrive::Organization.create(
  name: "Acme Inc",
  "sab55f505ca47dda0b4811f9ea5df00020540b80": "acme.com"
)
```

Yeah, we know what you are thinking, not convinient at all. Well, we definitely think the same, so we fixed it by abstracting us (the devs) from having to know such key.

So, using Pipedrive::Connect it is as it should always be:

```ruby
org = Pipedrive::Organization.create(
  name: "Acme Inc",
  domain: "acme.com"
)

# By the way, in case you are curious and want to know what all the fields
# within an Organization are, just call:
org.fields

# or, this works too
Pipedrive::Organization.fields
```

## Debuging

Show basic debugging info:

```ruby
Pipedrive.debug = true
```

show extended HTTP traffic information:

```ruby
Pipedrive.debug_http = true

# and to also show the body payloads
Pipedrive.debug_http_body = true
```

## Development

Run the set up:

```sh
$ bundle
```

Run the specs:

```sh
$ bundle exec rspec
```

Run the linter:

```sh
$ bundle exec rubocop
```

## Contributing

1. Fork it.
1. Create your feature branch (git checkout -b my-new-feature).
1. Commit your changes (git commit -am 'Add some feature').
1. Push to the branch (git push origin my-new-feature).
1. Create a new Pull Request.

Bug reports and pull requests are welcome on GitHub at https://github.com/getonbrd/pipedrive-connect. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/getonbrd/pipedrive-connect/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Pipedrive::Connect project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/getonbrd/pipedrive-connect/blob/master/CODE_OF_CONDUCT.md).
