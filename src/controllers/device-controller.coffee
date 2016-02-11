debug = require('debug')('meshblu:device-protocol-adapter-http')

class DeviceController
  constructor: ({@service}) ->

  getEnvelope: (req) =>
    message = req.body
    message = req.body.payload if req.body.payload?

    envelope =
      metadata:
        auth: req.meshbluAuth
      message: message.message
      config: req.meshbluAuth.device

    envelope

  getConfigEnvelope: (req) =>
    envelope =
      metadata:
        auth: req.meshbluAuth
      config: req.body

  config: (req, res) =>
    debug 'config', req.body
    envelope = @getConfigEnvelope(req)
    @service.onConfig envelope, =>
      return res.sendStatus(error.code || 500) if error?
      res.sendStatus 200

  received: (req, res) =>
    debug 'received', req.body
    envelope = @getEnvelope(req)
    @service.onMessage envelope, =>
      return res.sendStatus(error.code || 500) if error?
      res.sendStatus 200

module.exports = DeviceController
