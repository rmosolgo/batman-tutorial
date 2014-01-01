---
title: Modeling Events
layout: chapter
---

`Batman.Model`s handle data in a batman.js app. Let's get started on our first model: `Event`.

_From now on, "model" will refer to a subclass of `Batman.Model` and "record" will refer to an instance of a "model."_

`Event` will have three properties:

- `name` : string (required)
- `starts_at` : datetime (required)
- `ends_at` : datetime (if present, must be after `starts_at`)

## Ruby on Rails

<a name="generate_the_scaffold" class='batmantutorialheading'></a>
### Generate the scaffold
We'll need to implement this model on our server, with a RESTful JSON interface.

You can use a Rails generator to get started:

```
$ rails generate scaffold Event name:string starts_at:datetime ends_at:datetime
$ rake db:migrate
```

However, this inserts the Event routes above the exiting batman.js route. Open `<Rails root>/config/routes.rb` and make sure that

{% highlight ruby %}
resources :events
{% endhighlight %}

is __below__ the batman.js handler:

{% highlight ruby %}
get "(*redirect_path)", to: "batman#index", constraints: lambda { |request| request.format == "text/html" }
{% endhighlight %}

<a name="put_validations_on_the_model" class='batmantutorialheading'></a>
### Put validations on the model
Add the following lines to the class definition in `/app/models/event.rb`:

{% highlight ruby %}
validates_presence_of :name
validates_presence_of :starts_at
# something to validate ends_at > starts_at #todo
{% endhighlight %}

## Other backends

- REST API for `/events.json`
- Validates

## Batman.js

When your server is exposing a RESTful JSON API at `/events`, and performing the appropriate validations on incoming data, you're ready to go!

<a name="make_a_new_model" class='batmantutorialheading'></a>
### Make a new model
Models are defined in files like `/models/#{underscore-case model name}.js.coffee`. Make `/models/event.js.coffee` and add:

{% highlight coffeescript %}
class Events.Event extends Batman.Model
  @persist Batman.RestStorage
  @resourceName: 'events'
  @storageKey: 'events'

  @encode 'name', 'starts_at', 'ends_at'
{% endhighlight %}

If you're using Ruby on Rails, replace `@persist Batman.RestStorage` with:

{% highlight coffeescript %}
  @persist Batman.RailsStorage
  @encodeTimestamps()
{% endhighlight %}

So, what just happened?

- `@persist` was passes a `Batman.StorageAdapter`. This class controlls the persistence operations of our model (eg, when we call `save` on a record).
- The `@resourceName` property makes the model minification-safe. Also, `Batman.RestStorage` uses it as the base path for REST operations, so it should be the camel-cased version of the Model name.
- The `@storageKey` property will be used as the JSON namespace when performing REST operations.
- `@encode` told batman.js use those keys when going to and from JSON. (Any property which will be loaded from the server or sent to the server needs an encoder!)

<a name="take_er_for_a_spin" class='batmantutorialheading'></a>
### Take 'er for a spin
Start your development server, visit your root path, and open your JavaScript console. Let's see how these models work:

You can initialize a new `Event`:
{% highlight javascript %}
event = new Event.Events({name: "Pool Party"});
event.get('name');           // => "Pool Party"
event.get('isNew');          // => true
event.get('errors.length');  // => 0
event.set('name', 'Billiards Party');
event.get('name');           // => "Billiards Party"
{% endhighlight %}

And you can save it:
{% highlight javascript %}
event.save(function(err, savedEvent){
  if (err) {
    throw err
  }
  else {
    console.log(savedEvent.get('isNew')) // => false
    console.log(savedEvent.get('id'))    // => whatever Id was assigned by the server
  }
});
{% endhighlight %}

You can find it again from the server:
{% highlight javascript %}
//                vv Put your `event.get('id')` there
Events.Event.find(1, function(err, event){
  if (err) {
    throw err
  }
  else {
    console.log(event.get('name')); // => "Billiards Party"
  }
});
{% endhighlight %}

You can even destroy it:
{% highlight javascript %}
Events.Event.find(1, function(err, event){
  event.destroy(function(err) {
    if (err){ throw err }
  });
});
{% endhighlight %}

If you try to find it again:
{% highlight javascript %}
//                vv Put your `event.get('id')` there
Events.Event.find(1, function(err, event){
  if (err) {
    throw err
  }
  else {
    console.log(event.get('name')); // => "Billiards Party"
  }
});
{% endhighlight %}

It will throw `Uncaught NotFoundError: Record couldn't be found in storage!`

<a name="validations" class='batmantutorialheading'></a>
### Validations
You should always perform validations on the server. Client-side validations can be used to give a better user experience.

#### Presence

`name` and `starts_at` are required. Validate them by adding to your definition of `Event`:
{% highlight coffeescript %}
class Events.Event extends Batman.Model
  # ...
  @validate 'name', presence: true
  @validate 'starts_at', presence: true
{% endhighlight %}

You can verify this in your console:
{% highlight javascript %}
event = new Events.Event
event.validate()
event.get('errors.length') // => 2
event.get('errors.name.first.fullMessage') // => "Name can't be blank"
event.get('errors.starts_at.first.fullMessage') // => "Starts at can't be blank"
{% endhighlight %}

#### Custom Validator

Our need to ensure that `ends_at` is greater than `starts_at` (if `ends_at` is present) is more specific. We can define a class method on `Event` and use that as a validator. First, define the function (using the convention that methods beginning with `_` are private):

{% highlight coffeescript %}
class Event.Events
  # ...
  @_validateGreaterThanStartsAtIfPresent: (errors, record, key, callback) ->
      value = record.get(key)
      starts_at = record.get('starts_at')
      if value? && (value <= starts_at)
        errors.add(key, 'must be after "starts at"')
      callback()
{% endhighlight %}

Then apply the validator:

{% highlight coffeescript %}
  @validate 'ends_at', @_validateGreaterThanStartsAtIfPresent
{% endhighlight %}

Now, you can confirm it in the console:

{% highlight javascript %}
earlier = new Date
later = new Date // later by just a bit!
event = new Events.Event({starts_at: later, ends_at: earlier})
event.validate()
event.get('errors.ends_at.first.fullMessage') // => "Ends at must be after "starts at""
{% endhighlight %}

_For greater reusability, [extend Batman.Validator](#todo) and reuse your validation anywhere._

# Before you move on...

You've defined a model with persistence and validation. It communicates with the server via JSON REST. Great job!

# Extra
See [Adding File Uploads to Events.Event](#todo) to add an image property to this model!
