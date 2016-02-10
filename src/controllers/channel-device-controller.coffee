class ChannelDeviceController
  constructor: ({@service}) ->

  getEnvelope: (req) =>
    message = req.body
    message = req.body.payload if req.body.payload?

    envelope =
      metadata:
        auth: req.meshbluAuth
      message: message.data
      config: req.meshbluAuth.device

    envelope

  getConfigEnvelope: (req) =>
    envelope =
      metadata:
        auth: req.meshbluAuth
        config: req.body

  config: (req, res) =>
    @service.onConfig @getConfigEnvelope req, =>
      return res.sendStatus(error.code || 500) if error?
      res.sendStatus 200

  message: (req, res) =>
    @service.onMessage @getEnvelope(req), =>
      return res.sendStatus(error.code || 500) if error?
      res.sendStatus 200

  _encryptOptions: (req, res) =>
    config =
      auth: req.meshbluAuth
      options: req.meshbluAuth.device.options

    @service.encryptOptions config, (error) =>
      return res.sendStatus(error.code || 500) if error?
      res.sendStatus 200

  _message: (req, res) =>
    config =
      auth: req.meshbluAuth
      encryptedOptions: req.meshbluAuth.device.encryptedOptions
      message: req.body?.payload

    @service.processMessage config, (error) =>
      return res.sendStatus(error.code || 500) if error?
      res.sendStatus 200

module.exports = ChannelDeviceController
