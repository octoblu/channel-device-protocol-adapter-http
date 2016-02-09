ChannelDeviceController = require './src/controllers/channel-device-controller'

class Router
  constructor: ({service}, dependencies={}) ->
    console.log {service}
    @channelDeviceController = new ChannelDeviceController service

  route: (app) =>
    app.post '/message', @channelDeviceController.message
    app.post '/encrypt-options', @channelDeviceController.encryptOptions

module.exports = Router
