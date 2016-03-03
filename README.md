# authorize_if [![Gem Version](https://badge.fury.io/rb/authorize_if.svg)](https://badge.fury.io/rb/authorize_if) [![Build Status](https://travis-ci.org/vrybas/authorize_if.svg?branch=master)](https://travis-ci.org/vrybas/authorize_if) [![Code Climate](https://codeclimate.com/github/vrybas/authorize_if/badges/gpa.svg)](https://codeclimate.com/github/vrybas/authorize_if)

Minimalistic authorization library for Ruby on Rails applications. It
defines controller methods `authorize` and `authorize_if`, which accept
authorization rules and raise exception if rule evaluates to `false`.

And that's it.

## Installation

Add gem to your application's `Gemfile`:

    gem 'authorize_if'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install authorize_if

## Usage

### `authorize_if`

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
                 article.group.members.include?(current_user)
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

#### Exception handling

It raises `AuthorizeIf::NotAuthorizedError` exception, which you can
rescue right in the controller action

```ruby
class ArticlesController < ApplicationController
  def index
    authorize_if current_user
    # ...

  rescue AuthorizeIf::NotAuthorizedError
    head 403

  end
end
```

or with `rescue_from` in `ApplicaitonController`:

```ruby
class ApplicationController < ActionController::Base
  rescue_from "AuthorizeIf::NotAuthorizedError" do |exception|
    head 403
  end
end
```

#### Configuration

You can set custom error message by using configuration block

```ruby
class ArticlesController < ApplicationController
  def index
    authorize_if(current_user) do |config|
      config.error_message = "You are not authorized!"
    end
    # ...
  end
end

class ApplicationController < ActionController::Base
  rescue_from "AuthorizeIf::NotAuthorizedError" do |exception|
    render text: exception.message, status: 403
  end
end
```

### `authorize`

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

`authorize` accepts any parameters and passes them to authorization
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

It can also be customized by using configuration block.

```ruby
class ArticlesController < ActionController::Base
  def edit
    article = Article.find(params[:id])

    authorize(article) do |config|
      config.error_message = "You are not authorized!"
    end

    # ...
  end

  private

  def authorize_edit?(article)
    article.author == current_user
  end
end
```

#### Organizing authorization rules

You can always extract rules into a module and include them to the
controller.

```ruby
module AuthorizationRules
  def authorize_index?
    current_user.present?
  end
end

class ArticlesController < ActionController::Base
  include AuthorizationRules

  def index
    authorize

    # ...
  end
end
```


### Usage outside of controllers

Include `AuthorizeIf` to any class and you'll get `authorize` and
`authorize_if` methods.

## Contributing

1. Fork it ( https://github.com/vrybas/authorize_if/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

Copyright 2016 Vladimir Rybas. MIT License (see LICENSE for details).

