---
layout: chapter
title: "Event Belongs to Venue, Venue Has Many Events"
---

batman.js has an expressive, familiar API for handling relationships between models. Let's explore it by adding a new model, `Venue`, and relating to `Event` such that an event belongs to a venue and a venue has many events.


## Ruby on Rails

- `rails g scaffold Venue name:string capacity:integer`
- `rails g migration add_venue_id_to_events venue_id:integer`
- `rake db:migrate`
- Event `belongs_to :venue`, Venue `has_many :events, dependent: :nullify`
- update serialization of Event to include `venue_id`
- update strong params
- fix routes order


## Other backend

- Venue has name, capacity
- REST endpoint for Venue
- Event includes venue_id

## Batman.js

### Define Venue

Create `venue.js.coffee` in `/models` and define the model:

{% highlight coffeescript %}
class Events.Venue extends Batman.Model
  @persist Batman.RailsStorage # or Batman.RestStorage
  @encodeTimestamps() # Rails only
  @resourceName: 'venues'
  @storageKey: 'venues'

  @encode 'name', 'capacity'
{% endhighlight %}

### Relate Venue and Event

To define relationships on our models, we will call class methods inside the model definition, just like Rails:

{% highlight coffeescript %}
class Events.Venue extends Batman.Model
  # ...
  @hasMany 'events', autoload: false, inverseOf: 'venue'
{% endhighlight %}

{% highlight coffeescript %}
class Events.Event extends Batman.Model
  # ...
  @belongsTo 'venue', autoload: false, inverseOf: 'events'
{% endhighlight %}

#### Autoload

We've passed the option `autoload: false` because we haven't set up our server to implement the interface that batman.js expects. Without any other setup, `autoload` tries to load models from urls like `/events.json?venue_id=6` or `/venues.json?event_id=15`. Unless you're prepared to handle batman.js autoload requests, set `autoload: false` and load the records explicitly instead.

#### Inverse Of

Defining `inverseOf` will allow batman.js to populate the inverse associations of the related records when they're loaded from JSON. It doesn't maintain parity between different in-memory instances of the same record though, so be careful!

Of course, for a full description of the Batman.Model association options, see the [Batman docs](http://batmanjs.org/docs/api/batman.model_associations.html).

### Try it out in the console

Open your JavaScript console and try out your new association.

- Make a new venue:
{% highlight javascript %}
venue = new Events.Venue({name: "Mike's Bar", capacity: 100})
venue.save(function(err, savedVenue){
  if (err) {throw err}
  else {
    console.log(savedVenue.get('id')) // => probably 1
  }
})
{% endhighlight %}

- Load an event:
{% highlight javascript %}
Events.Event.load(function(err, events) {
  if (err) { throw err }
  else {
    window.firstEvent = events[0]
  }
})
{% endhighlight %}

- Then, set the event's venue:
{% highlight javascript %}
firstEvent.set('venue', venue)
firstEvent.save(function(err, ev) {
  if (err) { throw err }
  else {
    console.log(ev.toJSON()) // => should include `venue_id` equal to the ID logged above!
  }
})
{% endhighlight %}

- Reloading the event includes the `venue_id`:
{% highlight javascript %}
eventId = firstEvent.get('id')
Events.Event.clear()
Events.Event.find(eventId, function(err, event) {
  if (err) { throw err }
  else {
    console.log(event.get("venue_id")) // => returns the same ID logged above!
  }
})
{% endhighlight %}

### Controller and Views

- make a minimal Venue controller
- Add a select to the Events View
