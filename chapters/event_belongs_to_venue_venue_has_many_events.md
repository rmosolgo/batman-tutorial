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

- call relations methods
- explain Autoload

### Try it out in the console

- Create a venue, assign it to some events

### Controller and Views

- make a minimal Venue controller
- Add a select to the Events View
