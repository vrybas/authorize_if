# authorize_if

Minimalistic authorization for Ruby on Rails applications. It defines
a single method on controller, which can accept authorization rules and
raises exception if rule evaluates to `false`.

## API:

#### `authorize_if`

`authorize_if` accepts any object, which then is evaluated to `true` or
`false`.

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

It also accepts blocks. Exception is raised if block evaluates to `false`

```ruby
class ArticlesController
  def show
    authorize_if do
      false                 # <== exception is raised
    end

    # ...
  end
end
```

If you pass both the object and the block, the block can act as fallback
if object evaluates to `false`.

```ruby
class ArticlesController
  def show
    authorize_if(false) do
      true                 # <== exception is not raised
    end

    # ...
  end
end
```

AuthorizeIf raises `AuthorizeIf::NotAuthorizedError` exception, which
you can rescue with `rescue_from` in your `ApplicaitonController`:


```
class ApplicationController < ActionController::Base

  rescue_from "AuthorizeIf::NotAuthorizedError" do
    head 403
  end

end
```

