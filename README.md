# authorize_if

Minimalistic authorization for Ruby on Rails applications. It defines
one method on controllers:

`authorize_if`

And it raises `AuthorizeIf::NotAuthorizedError` exception, which
you can rescue and do whatever you demand.

## API:

#### `authorize_if`

`authorize_if` can accept booleans or truthy/falsey values:

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

It also accepts blocks. Exception is raised if block returns falsey
value.

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
if object evaluates to falsey.

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

