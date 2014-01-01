class Events.Event extends Batman.Model
  @persist Batman.RailsStorage
  @encodeTimestamps()
  @resourceName: 'events'
  @storageKey: 'events'

  @encode 'name',
  @encode 'starts_at', Batman.Encoders.railsDate
  @encode 'ends_at', Batman.Encoders.railsDate

  @validate 'name', presence: true
  @validate 'starts_at', presence: true

  @_validateGreaterThanStartsAtIfPresent: (errors, record, key, callback) ->
      value = record.get(key)
      starts_at = record.get('starts_at')
      if value? && (value <= starts_at)
        errors.add(key, 'must be after "starts at"')
      callback()

  @validate 'ends_at', @_validateGreaterThanStartsAtIfPresent

  @belongsTo 'venue', inverseOf: 'events'
