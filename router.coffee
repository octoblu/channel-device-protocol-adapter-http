DeviceController = require './src/controllers/device-controller'

class Router
  constructor: ({service}, dependencies={}) ->
    console.log {service}
    @DeviceController = new DeviceController {service}

  route: (app) =>
    app.post '/message', @DeviceController.message
    app.post '/config', @DeviceController.config

module.exports = Router
