# Hai

The easist way to create a CRUD GraphQL or Rest api with ruby.
Heavily inspired by [Ash Elixir](https://www.ash-elixir.org/)

Feedback is welcome and appreciated.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hai'
```

And then execute:

    $ bundle install

## Usage

Hai is a resource based api and those resources are ActiveRecord models. Keeping with this first principle, let's see how it can be used in your Ruby application.

## Action Modifications

If you want to modify any of the actions, you can add a Actions module to the
model that you want to modify.

```ruby
class Post < ApplicationRecord
  belongs_to :user

  module Actions
    def self.read(query, context)
      query.where(user_id: context[:user].id)
    end

    def self.list(query, context)
      query.where(user_id: context[:user].id)
    end

    def self.create(post, context)
      post.user = context[:user]
    end

    def self.update(post, context)
      post.last_updated_by = context[:user]
    end
  end
end
```
## Policies
Policies are handled in the same manner of Action Modifications. We will use the `Policies` module in the model to handle things like authorization.

```ruby
class Post < ApplicationRecord
  belongs_to :user

  module Policies
    def self.read(context)
      context[:user].can?(:read, context[:model])
    end

    def self.list(query, context)
      context[:user].can?(:list, context[:model])
    end

    # NOTE: create does a create or update
    def self.create(post, context)
      if post.persisted?
        post.user_id == context[:user].id
      else
        context[:user].can?(:create, context[:model])
      end
    end

    def self.update(post, context)
      post.user_id == context[:user].id
    end

    def self.delete(post, context)
      post.user_id == context[:user].id
    end
  end
end
```

## Graphql

Hai Graphql depends on `graphql-ruby` so if you don't have that installed and
boostrapped, head over to [ their repo and do that now ](https://github.com/rmosolgo/graphql-ruby#installation).

First, we have to load the Hai Graphql Types with the following snippet of code in your GraphQL::Schema file. Currently, order of operations matters so this needs to be called before the mutation and query class methods.

```ruby
class MyAppSchema < GraphQL::Schema
  include Hai::GraphQL::Types
  hai_types(User, Post) # comma list of the models you want to expose

  mutation(Types::MutationType)
  query(Types::QueryType)
  # ...
end
```

Now, if we want to add read operations (`readUser` and `listUsers`) complete with filtering, pagination, & sorting, we just have to declare it in the `Types::QueryType` file like so:

```ruby
module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    include Hai::GraphQL
    hai_query(User)
  end
end
```

Lastly, if you want to add mutations (`createUser`, `updateUser`, & `deleteUser`), you simply declare which models you'd like to expose in the `Types::MutationType` file.

```ruby
module Types
  class MutationType < Types::BaseObject
    include Hai::GraphQL
    hai_mutation(User)
  end
end
```

## Rest

This is even easier than adding Hai Graphql. Hai Rest is a dynamic engine that can be mounted with any namespace. You just have to mount it in your routes file like this:

```ruby
Rails.application.routes.draw do
  mount Hai::Rest::Engine => "/rest"
end
```

Example queries for rest.
#### List all users

Simple use case

`GET <base_url>/rest/users`

You can also filter:

`GET <base_url>/rest/users?filter[name][eq]=bob`

Sort

`GET <base_url>/rest/users?sort[field]=name&sort[direction]=desc`

Paginate

`GET <base_url>/rest/users?limit=10&offset=20`

Or all things combined

`GET <base_url>/rest/users?filter[name][eq]=bob&sort[field]=name&sort[direction]=desc&limit=10&offset=20`

#### Read a specific user

`GET <base_url>/rest/users/1`

#### Create a user

`POST <base_url>/rest/users`

```JSON
{
    "user": {
        "name": "bob"
    }
}
```

#### Update a user
`PUT <base_url>/rest/users/1`

```JSON
{
    "user": {
        "name": "bob"
    }
}
```

#### Delete a user
`DELETE <base_url>/rest/users/1`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/[USERNAME]/hai.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
