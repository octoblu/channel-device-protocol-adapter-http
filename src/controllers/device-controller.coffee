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
    envelope = @getConfigEnvelope(req)
    @service.onConfig envelope, =>
      return res.sendStatus(error.code || 500) if error?
      res.sendStatus 200

  message: (req, res) =>
    envelope = @getEnvelope(req)
    @service.onMessage envelope, =>
      return res.sendStatus(error.code || 500) if error?
      res.sendStatus 200

module.exports = DeviceController
