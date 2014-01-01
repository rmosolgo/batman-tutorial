---
title: Gathering and Displaying Information
layout: chapter
---

The crucial connection between data the rendered page is provided by batman.js's __view bindings__. View bindings are HTML attributes that link properties of batman.js objects to DOM nodes.

Let's learn about view bindings by building views for our `Event` Model

## Batman.js

To provide a UI for our `Event` model, we'll:

- tell our app which requests to handle by updating our routes
- tell our app how to handle those requests by creating an `EventsController`
- provide templates for the actions of `EventsController`
- fill those templates with view bindings

<a name="routing_events" class='batmantutorialheading'></a>
### Routing events
Open `events.js.coffee` and add routes for `events`:

{% highlight coffeescript %}
class Events extends Batman.App
  # ...
  @resources 'events'
{% endhighlight %}

`@resources` follows a [Rails convention](#todo) and automatically creates this route-to-controller-action mapping:

- `'/events'` &rarr; `'events#index'`
- `'/events/new'` &rarr; `'events#new'`
- `'/events/:id'` &rarr; `'events#show'`
- `'/events/:id/edit'` &rarr; `'events#edit'`

If you're familiar with this pattern, you might notice that `destroy` and `create` routes are missing. Given the fact that a single-page appliation is fundamentally stateful (whereas a REST-based web app is stateless), these actions are accomplished in a different way. Read on!

<a name="handling_requests_for_events" class='batmantutorialheading'></a>
### Handling requests for events
Calling `@resources 'events'` depends on having an `EventsController`. Let's define it in `/controllers/events_controller.js.coffee`:

{% highlight coffeescript %}
class Events.EventsController extends Events.ApplicationController
  routingKey: 'events'
{% endhighlight %}

_The `routingKey` makes the controller minification-safe._

Also, `@resources` will expect some actions on that controller, so lets start defining them:

{% highlight coffeescript %}
class Events.EventsController extends Events.ApplicationController
  # ...
  index: (params) ->
    # to do!

  new: (params) ->
    # to do!

  show: (params) ->
    # to do!

  edit: (params) ->
    # to do!
{% endhighlight %}

So, what should these actions do? HTML templates are responsible for generating HTML and `Batman.View`s are responsible for managing user interactions with their HTML, so where do controllers fit in? Generally speaking, batman.js controllers should mediate interactions between views and models, inluding:

- loading loaded from storage
- managing persistence operations of records

Similar to Rails controllers, we will load records from storage (or initialize new ones), assign them to instance variables of the controller then use those records in our views. Let's start with the `show` action of `EventsController`:

{% highlight coffeescript %}
class Events.EventsController extends Events.ApplicationController
  # ...
  show: (params) ->
    Events.Event.find(params.id, (err, event) =>
      throw err if err
      @set("currentEvent", event)
    )
{% endhighlight %}

A few things to keep in mind:

- the first argument in a controller action is an object with the request parameters in it, including named parameters from the route pattern _and_ parameters from the query string.
- using the __CoffeeScript fat arrow__ (`=>`) means that `@` in the callback refers to the `EventsController` instance
- use `@set(key, value)` to set observable properties on the controller instance. They'll be accessible (and observable) inside our HTML data bindings. By using `set` (and its partner, `get`), all references to this value will be updated when the value changes. Win!
- there's no explicit call to `render`. Instead, we'll delegate to batman.js's implicit render call at the end of the controller call chain.


With this controller action, we'll load a record from storage and make it accessible and observable to our view.


<a name="view_and_template" class='batmantutorialheading'></a>
### View and Template
When using `@resources` in your app's routes, batman.js will subclass `Batman.View` on the fly, meaning that you don't have to define one yourself (but you may -- in which case it will use your implementation).  The automatically-created view will also default to check for a template with the name `"html/#{camel-cased resource name}/#{action name}.html"`. In our case, that's `"html/events/show.html"`.

So, our corresponding view class `Events.EventsShowView` will be created for us on the fly -- let's not worry about it right now. But let's create the template that the implicitly-created view will use to render.

Open `/html/events/show.html` and add:

{% highlight html %}
<h2>
  Event:
  <span data-bind='currentEvent.name'></span>
</h2>
<p>
  Starts at:
  <span data-bind='currentEvent.starts_at'></span>
</p>
<p>
  Ends at:
  <span data-bind='currentEvent.ends_at'></span>
</p>
{% endhighlight %}

Check out those data bindings! If you guessed that `currentEvent` refers to the event we set on our controller, you're right! For kicks, open your browser and visit a page for an event that doesn't exist yet, say `/events/1234`.

You should see an empty template. It's empty because the record wasn't loaded from storage. If you open your browser's JavaScript console, you will see `"Uncaught NotFoundError: Record couldn't be found in storage!"`. Anyways, it's enought to know that our app is wired up correctly. The route invokes `EventsController`, which renders the HTML we gave it.

If you want to see your template in action, create an event in your JavaScript console, then visit its `show` page:

{% highlight javascript %}
event = new Events.Event({name: "Game Night", starts_at: new Date})
event.save(function(err, savedEvent){
  if (err) { throw err }
  else {
    id = savedEvent.get('id')
    Batman.redirect("/events/" + id)
  }
})
{% endhighlight %}

You should see your template, with `Game Night` and the current time rendered in it.

<a name="span_data_bind" class='batmantutorialheading'></a>
### span data-bind
Using `<span data-bind='some.value'></span>` is a very common way to render dynamic values into static text. Don't hesitate to use it when developing a batman.js application!

<a name="the_index_view" class='batmantutorialheading'></a>
### The index view
We'll do something very similar to implement a list of events:

- create a controller action to fetch all events and set them on the controller
- let batman.js create the view for us
- create a HTML template to render the list of events


Here's the controller action:

{% highlight coffeescript %}
class Events.EventsController extends Events.ApplicationController
  # ...
  index: (params) ->
    @set('events', Events.Event.get('all'))
{% endhighlight %}

This is actually a great example of batman.js data binding.  `Model.get('all')` does two things: it returns the set of records that are already in memory (accessible themselves as `Model.get('loaded')`) and fires an AJAX request to reload records from the server. since you'll be binding to the set of loaded records, when that AJAX request finishes, the set will be updated and your view will automatically be updated to reflect any changes. Yeah!

Let's take advantage of that observable data with some view bindings:

{% highlight coffeescript %}
<h2>All Events<h2>
<p>
  There are
  <span data-bind='events.length'></span>
  upcoming events!
</p>
<ul>
  <!-- `event` by itself is naming conflict! -->
  <li data-foreach-upcomingevent='events'>
      <a data-route='routes.events[upcomingevent]'>
        <span data-bind='upcomingevent.name'></span>
        <span data-bind='upcomingevent.starts_at | prepend "(" | append ")"'></span>
      </a>
  </li>
</ul>
{% endhighlight %}

This introduces a few new things:

<a name="view_filters" class='batmantutorialheading'></a>
### view filters
View filters allow you to modify values before they're rendered into HTML. When you bind a value to a node, you can pass the value through a chain of filters. When the value changes, it is passed through the filters again, then the result is rendered into HTML.

With view filters, the output of the first filter becomes the first argument of the second filter, so:
{% highlight html %}
<span data-bind='"person" | pluralize upcomingevent.attending.length | capitalize'></span>
{% endhighlight %}
renders to "1 Person" or "5 People", depending on the value of `upcomingevent.attending.lenght`

View filters (and view bindings) take either literal values:
{% highlight html %}
<span data-bind='"string literal" | pluralize 5 | '></span>
{% endhighlight %}

Or variables accessible in the _current context_:
{% highlight html %}
<p>
  <!-- the app is always available -->
  <span data-bind='Event.all.length'></span> Events in total
</p>
<p>
  <!-- values set in the controller or view (or superviews) are available -->
  <span data-bind='currentEvent.name'></span> is coming soon!
</p>
{% endhighlight %}

<a name="double_dash_view_bindings" class='batmantutorialheading'></a>
### double-dash view bindings
Some view bindings take a parameter in the _key_ of the HTML element. For example, the `data-foreach` binding above takes `upcomingevent` as a parameter. To using a binding like this, use the syntax:

{% highlight coffeescript %}
"data-#{bindingName}-#{yourParameter}"
{% endhighlight %}

Your parameter comes after the second dash, hence the name "double-dash syntax". The parameter after the dash __may__ include a dash itself, so `data-addclass-icon-ready='model.ready'` is a valid binding.

Double-dash view bindings include:

- `data-foreach-#{itemName}='collectionKeypath'` creates one of the bound element for each item in `collection`. Inside the bound element, the item is bindable as `itemName`.
- `data-addclass-#{className}='valueKeypath'` adds class `className` to the element if `'value'` is truthy.
- `data-removeclass-#{className}='valueKeypath'` removes class `className` to the element if `'value'` is truthy.
- `data-bind-#{attributeName}='valueKeypath'` adds the attribute `attributeName` if the `'value'` is truthy and removes it if `'value'` is falsy.
- `data-event-#{eventName}="handlerKeypath"` when `eventName` is fired on the bound element, the handler on `handlerKeypath` is fired. Valid `eventName`s are "click", "doubleclick", "change" and "submit".
- `data-context-#{contextName}='someLongKeypath` makes the value at `someLongKeypath` accessible as `contextName`.

<h3 id='data_route'>data-route</h3>

When you want to link to another page in your batman.js app, you should use the `data-route` view binding. Using this binding (rather than the `href` attribute) makes your links more maintainable because if you change your routing (model `resourceName`, `Batman.config.pathToApp`), your `NamedRouteQuery` will still resolve. You won't have to find-and-replace a bunch of `href`s! Don't worry, `data-route` renders the URL into the `href` attribute so that native browser features (like `"Copy link address"` and Alt-click actions) still work.

Data-route is often used with a `NamedRouteQuery`, which is way of referencing your app's routes by name. Since we used `@resources`, the routes are pretty simple:

- To point to the _index_ action's route (`/events`):
  {% highlight html %}
  <!-- events#index -->
  <a href='routes.events'>All events</a>
{% endhighlight %}

- To point to `events#new`:
  {% highlight html %}
  <!-- events#new -->
  <a href='routes.events.new'>All events</a>
{% endhighlight %}

- To point to actions for a single record:
  {% highlight html %}
  <!-- events#show -->
  <a href='routes.events[upcomingevent]'>See this event</a>
  <!-- events#edit -->
  <a href='routes.events[upcomingevent].edit'> Edit this event</a>
  <!-- events#customAction -->
  <a href='routes.events[upcomingevent].customAction'> Edit this event</a>
{% endhighlight %}

A few general points about `NamedRouteQuery`:

- within view bindings, begin all route queries with `routes.`
- to access a controller in your route query, append it as `.#{controllerName}`
- to access an action on a controller, append it as `.#{actionName}`
- if the route needs some data (for example, `id`s), pass it to the query with `[param]`. Square brackets are shorthand for `#get` inside a keypath or route query.

Data-route may also take a string literal:

{% highlight html %}
<a data-route='"/"'>Home</a>
<a data-route='"/about/team"'>About our team</a>
{% endhighlight %}

Notice _two sets of quotes_, one for the HTML attribute value and other to make it a string literal for the view binding.
