# Burgundy

[![Tests](https://github.com/fnando/burgundy/workflows/ruby-tests/badge.svg)](https://github.com/fnando/burgundy)
[![Gem](https://img.shields.io/gem/v/burgundy.svg)](https://rubygems.org/gems/burgundy)
[![Gem](https://img.shields.io/gem/dt/burgundy.svg)](https://rubygems.org/gems/burgundy)
[![MIT License](https://img.shields.io/:License-MIT-blue.svg)](https://tldrlegal.com/license/mit-license)

A simple wrapper for objects (think of Burgundy as a decorator/presenter) in
less than 150 lines.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "burgundy"
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install burgundy
```

## Usage

First, define your wrapping class.

```ruby
class UserPresenter < Burgundy::Item
end
```

Then you can instantiate it:

```ruby
user = UserPresenter.new(User.first)
```

The `Burgundy::Item` has access to helper and route methods. Notice that the
wrapper item is accessible through the `Burgundy::Item#item` method.

```ruby
class UserPresenter < Burgundy::Item
  def profile_url
    routes.profile_url(item.username)
  end
end
```

You don't have to expose attributes; everything is delegated to the wrapped
item.

To wrap an entire collection, just use the `Burgundy::Item.wrap` class.

```ruby
class WorkshopsController < ApplicationController
  def index
    @workshops = WorkshopPresenter.wrap(Workshop.sorted_by_name)
  end
end
```

Alternatively, you can also use the `Burgundy::Collection` class.

```ruby
class WorkshopsController < ApplicationController
  def index
    @workshops = Burgundy::Collection.new(
      WorkshopPresenter,
      Workshop.sorted_by_name
    )
  end
end
```

You may need to provide additional arguments to the item class. On your
collection, all additional arguments will be delegated to the item classe, like
the following example:

```ruby
WorkshopPresenter.wrap(Workshop.all, current_user)
Burgundy::Collection.new(Workshop.all, WorkshopPresenter, current_user)

class WorkshopPresenter < Burgundy::Item
  def initialize(workshop, current_user)
    super(workshop)
    @current_user = current_user
  end
end
```

You can also use keyword arguments to pass in additional objects.

```ruby
WorkshopPresenter.wrap(Workshop.all, current_user:)
Burgundy::Collection.new(Workshop.all, WorkshopPresenter, current_user:)

class WorkshopPresenter < Burgundy::Item
  def initialize(workshop, current_user:)
    super(workshop)
    @current_user = current_user
  end
end
```

> [!NOTE]
>
> The target object will always be a positional argument.

The query will be performed only when needed, usually on the view (easier to
cache). The collection is an enumerable object and can be passed directly to the
`render` method. Each item will be wrapped by the provided class.

```erb
<%= render @workshops %>
```

Route URLs may require the default url options. Burgundy try to get them from
the following objects:

- `Rails.configuration.action_mailer.default_url_options`
- `Rails.application.routes.default_url_options`

So you can just put this on your environment file

```ruby
config.action_controller.default_url_options = {
  host: "example.org"
}
```

You can map attributes into a hash; I use this strategy for using presenters on
API responses (so you can skip adding yet another dependency to your projects).

```ruby
class UserPresenter < Burgundy::Item
  attributes :username, :name, :email

  def profile_url
    routes.profile_url(item.username)
  end
end

UserPresenter.new(User.first).attributes
#=> {:username=>'johndoe', :name=>'John Doe', :email=>'john@example.org'}

UserPresenter.new(User.first).to_hash
#=> {:username=>'johndoe', :name=>'John Doe', :email=>'john@example.org'}

UserPresenter.new(User.first).to_h
#=> {:username=>'johndoe', :name=>'John Doe', :email=>'john@example.org'}

UserPresenter.new(User.first).as_json
#=> {:username=>'johndoe', :name=>'John Doe', :email=>'john@example.org'}
```

Notice that `as_json` will ignore any options provided.

If you want to remap an attribute, provide a hash.

```ruby
class UserPresenter < Burgundy::Item
  attributes :name, :email, username: :login

  def profile_url
    routes.profile_url(item.username)
  end
end

UserPresenter.new(User.first).attributes
#=> {:login=>'johndoe', :name=>'John Doe', :email=>'john@example.org'}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2013 Nando Vieira

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
