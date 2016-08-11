# authorize_if [![Gem Version](https://badge.fury.io/rb/authorize_if.svg)](https://badge.fury.io/rb/authorize_if) [![Build Status](https://travis-ci.org/vrybas/authorize_if.svg?branch=master)](https://travis-ci.org/vrybas/authorize_if) [![Code Climate](https://codeclimate.com/github/vrybas/authorize_if/badges/gpa.svg)](https://codeclimate.com/github/vrybas/authorize_if)

Minimalistic authorization library for Ruby on Rails applications. It
defines controller methods `authorize_if` and `authorize`, which
evaluate inline or pre-defined authorization rules and raise exception
if rule evaluates to `false`.

## API documentation

#### Contents:

##### [`authorize_if`](#authorize_if) - inline authorization
* [Exception handling](#exception-handling)
* [Customization of an exception object](#customization-of-an-exception-object)

##### [`authorize`](#authorize) - authorization using pre-defined authorization rules
* [Organizing authorization rules](#organizing-authorization-rules)

##### [`Installation`](#installation-1)

##### [`Contributing`](#contributing-1)

##### [`License`](#license-1)

- - -

## `authorize_if`

Accepts any `truthy` or `falsey` Ruby object.

```ruby
class ArticlesController < ActionController::Base
  def index
    authorize_if current_user
    # ...
  end

  def show
    article = Article.find(params[:id])

    authorize_if article.authored_by?(current_user) ||
                 article.published?
    # ...
  end

  def edit
    article = Article.find(params[:id])

    authorize_if can_manage?(article)
    # ...
  end

  private

  def can_manage?(article)
    # ...
  end
end
```

### Exception handling

It raises `AuthorizeIf::NotAuthorizedError` exception, which you can
rescue right in the controller action

```ruby
class ArticlesController < ApplicationController
  def index
    authorize_if current_user
    # ...

  rescue AuthorizeIf::NotAuthorizedError
    head 404

  end
end
```

or with `rescue_from` in `ApplicationController`:

```ruby
class ApplicationController < ActionController::Base
  rescue_from AuthorizeIf::NotAuthorizedError do |exception|
    head 404

  end
end
```

### Customization of an exception object

If block is given, `authorize_if` yields the block with an exception
object. This allows to set custom error message, which is going to be
used when exception is raised.

Also you can use key-value store(plain Ruby hash), `context`, to store
any data, and access it in the exception handling block.

```ruby
class ArticlesController < ApplicationController
  def index
    authorize_if(current_user) do |exception|
      exception.message = "You are not authorized!"

      exception.context[:request_ip] = "192.168.1.1"
    end
    # ...
  end
end
```

```ruby
class ApplicationController < ActionController::Base
  rescue_from AuthorizeIf::NotAuthorizedError do |exception|
    exception.message
    # => "You are not authorized!"

    exception.context[:request_ip]
    # => "192.168.1.1"
  end
end
```

## `authorize`

You can define authorization rules for controller actions like this

##### `"authorize_#{action_name}?"`

And then call `authorize`, which is going to find and evaluate
corresponding authorization rule.

```ruby
class ArticlesController < ActionController::Base
  def index
    authorize

    # ...
  end

  private

  def authorize_index?
    current_user.present?
  end
end
```

`authorize` accepts any arguments and passes them to authorization
rule.

```ruby
class ArticlesController < ActionController::Base
  def edit
    article = Article.find(params[:id])

    authorize(article)

    # ...
  end

  private

  def authorize_edit?(article)
    article.author == current_user
  end
end
```

It also accepts customization block, and yields an exception object:

```ruby
class ArticlesController < ActionController::Base
  def edit
    article = Article.find(params[:id])

    authorize(article) do |exception|
      exception.message = "You are not authorized!"
      exception.context[:request_ip] = "192.168.1.1"
    end

  rescue AuthorizeIf::NotAuthorizedError => e
    e.message
    # => "You are not authorized!"

    e.context[:request_ip]
    # => "192.168.1.1"
  end

  private

  def authorize_edit?(article)
    article.author == current_user
  end
end
```

### Organizing authorization rules

You can extract rules into a module and include it to the
controller.

```ruby
class ArticlesController < ActionController::Base
  include AuthorizationRules

  def index
    authorize

    # ...
  end
end
```

```ruby
module AuthorizationRules
  def authorize_index?
    current_user.present?
  end
end
```

## Usage outside of controllers

Include `AuthorizeIf` module to any class and you'll get `authorize` and
`authorize_if` methods.

## Installation

Add gem to your application's `Gemfile`:

    gem 'authorize_if'

And then execute:

    $ bundle

Or install it manually:

    $ gem install authorize_if

## Contributing

1. Fork it ( https://github.com/vrybas/authorize_if/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

Copyright 2016 Vladimir Rybas. MIT License (see LICENSE for details).

