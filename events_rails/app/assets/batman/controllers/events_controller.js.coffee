class Events.EventsController extends Events.ApplicationController
  routingKey: 'events'

  show: (params) ->
    Events.Event.find(params.id, (err, event) =>
      throw err if err
      console.log event
      @set("currentEvent", event)
    )

  index: (params) ->
    @set('events', Events.Event.get('all'))
