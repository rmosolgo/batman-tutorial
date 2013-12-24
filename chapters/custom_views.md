---
title: Custom Views
layout: chapter
---

To render HTML in a page, batman.js uses HTML templates and `Batman.View`s. Custom views are great for commonly-reused content like headers, footers or complex UI elements.

In traditional MVC structure, there is generally one view rendered for any controller action. However, batman.js views are more versatile. There can be any number of views active on a given page. In terms of Ruby on Rails, they're more like views, partials and view helpers all together.

Let's use a custom view to add a header to our Events app!

## Ruby on Rails

Your main layout was provided by `batman-rails` when you ran `rails generate batman:app`. It's in `<Rails root>/app/views/layout/batman.html.erb`. Open that file and add the `header` tag like this:

{% highlight html %}
<body>
  <header data-view="HeaderView"></header>
  <div data-yield="main"></div>
  <!-- other stuff -->
</body>
{% endhighlight %}

The `header` should be inside the `body` and before the `div` that has `data-yield="main"`. The `header` should have `data-view="HeaderView"`. Our header will be `Events.HeaderView`, and this is how batman.js will know to render that view inside that `header`.

## Other backend

- Make sure layout is present
- Add the `data-view="HeaderView"` header tag

## Batman.js

To render custom views, you need two things:

- __a view:__ a subclass of `Batman.View` defined in a file in `/views`
- __a template:__ HTML provided in `/html` and referenced by the __view__'s `source` property.

So let's get to work!

### Make a custom view

`Batman.View`s are objects that can be rendered into the page. Generally, views are rendered via one of two ways:

- call to `@render` inside a controller action (implicit or explicit)
- rendered by a `data-view` view binding.

To make a custom view, make "/views/header_view.js.coffee" and put this code in it:

{% highlight coffeescript %}
class Events.HeaderView extends Batman.View
  source: 'header_view'
{% endhighlight %}

You have defined a new view. By providing `source: 'header_view'`, you have also specified the source for its HTML: `/html/header_view.html`. Whenever this view is rendered, batman.js will use that HTML as its template.

### Make a template

Open `/html/header_view.html` and add:

{% highlight html %}
<h1> Events </h1>
<!-- header code -->
{% endhighlight %}

