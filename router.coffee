meshbluAuth        = require 'express-meshblu-auth'

DeviceController = require './src/controllers/device-controller'
ManagementController = require './src/controllers/management-controller'

class Router
  constructor: ({service, @meshbluConfig}, dependencies={}) ->
    @deviceController = new DeviceController {service}
    @managementController = new ManagementController {service}

  route: (app) =>
    #unauthenticated
    app.get '/authenticate', @managementController.authenticate
    app.get '/authenticated', @managementController.authenticated

    #authenticated
    app.use meshbluAuth(@meshbluConfig)
    app.get '/authorize', @managementController.authorize
    app.post '/received', @deviceController.received
    app.post '/config', @deviceController.config

module.exports = Router
