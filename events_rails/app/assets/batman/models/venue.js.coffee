class Events.Venue extends Batman.Model
  @persist Batman.RailsStorage
  @encodeTimestamps()
  @resourceName: 'venues'
  @storageKey: 'venues'

  @hasMany 'events', inverseOf: 'venue', autoload: false

  @encode 'name', 'capacity'
