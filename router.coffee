ChannelDeviceController = require './src/controllers/channel-device-controller'

class Router
  constructor: ({@service}, dependencies={}) ->
    @channelDeviceController = new ChannelDeviceController @service

  route: (app) =>
    app.post '/message', @channelDeviceController.message
    app.post '/encrypt-options', @channelDeviceController.encryptOptions

module.exports = Router
