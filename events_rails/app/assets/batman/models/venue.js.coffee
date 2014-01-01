class Events.Venue extends Batman.Model
  @persist Batman.RailsStorage
  @encodeTimestamps()
  @resourceName: 'venues'
  @storageKey: 'venues'

  @encode 'name', 'capacity'
