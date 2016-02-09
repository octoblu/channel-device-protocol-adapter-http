class ChannelDeviceController
  constructor: ({@service}) ->

  encryptOptions: (req, res) =>
    config =
      auth: req.meshbluAuth
      options: req.meshbluAuth.device.options

    @service.encryptOptions config, (error) =>
      return res.sendStatus(error.code || 500) if error?
      res.sendStatus 200

  message: (req, res) =>
    config =
      auth: req.meshbluAuth
      encryptedOptions: req.meshbluAuth.device.encryptedOptions
      message: req.body?.payload

    @service.processMessage config, (error) =>
      return res.sendStatus(error.code || 500) if error?
      res.sendStatus 200

module.exports = ChannelDeviceController
