# authorize_if

Minimalistic authorization for Ruby on Rails applications. It defines
three methods on controllers:

`authorize_if`, `authorize_unless`, and `authorize` to use former with
less duplication.

And it raises `YourApplicationName::NotAuthorized` exception, which you
can rescue and do whatever you demand.

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

It also accepts blocks:

```ruby
class ArticlesController
  def show
    authorize_if do
      # more complex authorization rule
    end

    # ...
  end
end
```

#### `authorize_unless`

`authorize_unless` has the same signature, as `authorize_if`, but
inverted:

```ruby
class ArticlesController
  def show
    authorize_unless current_user.blocked?
    # ...
  end
end
```

#### `authorize`

`authorize` method delegates to instance method `authorize_...?` with
the name of a caller:

```ruby
class ArticlesController
  def index
    authorize           # <-- calls `authorize_index?`
    # ...
  end

  def create
    authorize           # <-- calls `authorize_create?`
    # ...
  end

  private

  def authorize_index?
    # ...
  end

  def authorize_create?
    # ...
  end
end
```

This can be extracted to `before_action`:

```ruby
class ArticlesController
  before_action :authorize

  def index
    # ...
  end

  def create
    # ...
  end

  private

  def authorize_index?
    # ...
  end

  def authorize_create?
    # ...
  end
end
```

Those authorization rules can be extracted to a module:

```ruby
module AuthorizationRules
  private

  def authorize_index?
    # ...
  end

  def authorize_create?
    # ...
  end
end

class ArticlesController
  include AuthorizationRules

  before_action :authorize

  def index
    # ...
  end

  def create
    # ...
  end
end

```

`authorize` can accept parameters, and `authorize_...?` method is called
with whatever parameters are given:

```ruby
class ArticlesController
  def show
    authorize article   # <-- calls `authorize_show?(article)`
    # ...
  end

  private

  def authorize_show?(article)
    # ...
  end
end

class ArticlesController
  def show
    authorize model: article,      # <-- calls `can_show?` with whatever
              user:  current_user  #     parameters are given.
    # ...
  end

  private

  def authorize_show?(model:, user:)
    # ...
  end
end
```


### Advanced usage of `authorize_if`.

`authorize_if` accepts callable objects(procs, lambdas or any other
object, which responds to `:call`). `call` is executed with one single
argument, which is an object, which called `authorize_if` method.

```ruby
class ArticlesController
  MyAuthRule = -> () do
    # ...
  end

  def show
    authorize_if MyAuthRule
    # ...
  end
end
```

