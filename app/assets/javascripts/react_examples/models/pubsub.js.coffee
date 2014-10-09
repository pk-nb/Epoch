# https://github.com/jackfranklin/CoffeePubSub

class Pubsub
  constructor: ->
    @subs = {}

  sub: (id, evt, cb) ->
    if @_isSubscribed evt
      sub = @subs[evt]
      sub.push {id: id, callback: cb}
    else
      @subs[evt] = [{id: id, callback: cb}]



  _isSubscribed: (evt) ->
    @subs[evt]?

  unSub: (id, evt) ->
    return false if not @_isSubscribed evt
    newSubs = []
    for sub in @subs[evt]
      newSubs.push sub if sub.id isnt id
    if newSubs.length is 0
      delete @subs[evt]
    else
      @subs[evt] = newSubs



  pub: (evt, info) ->
    for key, val of @subs
      return false if not val?
      if key is evt
        for data in val
          data.callback(info)


@.EpochModel ?= {}
@.EpochModel.Pubsub = Pubsub
