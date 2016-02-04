# authorize_if

Minimalistic authorization for Ruby on Rails applications. It defines
controller methods `authorize` and `authorize_if`, which accept
authorization rules and raise exception if rule evaluates to `false`.
That's it.

#### `authorize_if`

`authorize_if` accepts any `truthy` or `falsey` Ruby object.

```ruby
class ArticlesController
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

It raises `AuthorizeIf::NotAuthorizedError` exception, which you can
rescue right in the controller method

```ruby
class ArticlesController
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

You can set custom error message by using configuration block

```ruby
class ArticlesController
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

#### `authorize`

This method helps to extract authorization rules out of controller. It
expects corresponding authorization rule to exist.

```ruby
class ArticlesController
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

You can extract those rules into a module and include them to the
controller.

```
module AuthorizationRules

  private

  def authorize_index?
    current_user.present?
  end
end

class ArticlesController
  include AuthorizationRules

  def index
    authorize

    # ...
  end
end
```

`authorize` accepts any parameters and passes them to authorization
rule(except for given block).

```ruby
class ArticlesController
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
class ArticlesController
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

