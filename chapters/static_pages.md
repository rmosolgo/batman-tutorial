---
title: Static Pages
layout: chapter
---

Let's get your app to serve a new home page. We'll cover routing, controllers, and HTML templates.

## Ruby on Rails
- application layout is already defined

## Other backend
- Make sure layout is present (if needed?)

## Batman.js

### Make a new route in your app definition

Open `events.js.coffee`. You should see:

{% highlight coffeescript %}
class Events extends Batman.App
{% endhighlight %}

This is your app definition. This is where you will add _routing_, code that creates a mapping between request paths (ie, the text in your browser's address bar, for example "/home") and controllers, which are CoffeeScript classes that tell your app what to do with that request.

We know we want to route the _root path_, `"/"`, to a static page called "home", so add this line to your app definition:

{% highlight coffeescript %}
class Events extends Batman.App
  @root 'staticPages#home' # `staticPages` refers to StaticPagesController, `home` is an action of that controller
{% endhighlight %}

Make sure that any other mapping with `root` is removed. (If you're using Rails, remove `root "main#index"`).

Now open your browser and visit your app's root path. You should see a blank screen. batman.js is trying to dispatch the `"home"` action of the `StaticPagesController`, but failing, because we haven't created `StaticPagesController` yet!

### Make a controller to handle requests

In your `controllers` directory, make a new file called `static_pages_controller.js.coffee` and add this code:

{% highlight coffeescript %}
class Events.StaticPagesController extends Events.ApplicationController
  routingKey: "static_pages"

  home: (params) ->

{% endhighlight %}

You have just defined a new controller, `StaticPagesController` and defined its `home` action. Notice that `home` has no function body. Since we're just rendering some HTML, we'll defer to to batman.js's implicit call to `render` at the end of the controller call chain.

### HTML templates go in `/html`

Let's create our new homepage. In your `/html` directory, create a new directory called `static_pages`. Inside that directory, open a file and save it as "home.html". Give it this content:

{% highlight html %}
<h1> Events App </h1>
<p> Powered by batman.js </p>
{% endhighlight %}

Batman.js will use this HTML as a template when rendering views. It will be found automatically because:

- The folder name is the underscore-case controller name
- The file name is the same as the controller action name


# Before moving on...

Start your development server and visit the root path. You should see your new home page ("Events App Powered by batman.js"). If you do, then batman.js successfully routed the request to `StaticPagesController`'s  `home` action!

