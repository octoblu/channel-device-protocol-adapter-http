url                  = require 'url'
meshbluAuth          = require 'express-meshblu-auth'
DeviceController     = require './src/controllers/device-controller'
ManagementController = require './src/controllers/management-controller'

class Router
  constructor: ({service, @meshbluConfig}, dependencies={}) ->
    @deviceController = new DeviceController {service}
    @managementController = new ManagementController {service}

  route: (app) =>
    #unauthenticated - get meshblu creds
    app.get '/authenticate', @managementController.authenticate
    app.get '/authenticated', @managementController.authenticated

    app.use meshbluAuth @meshbluConfig, errorCallback: (error, {req, res}) =>
      console.log 'couldnt auth, redirectn'
      res.redirect @getOctobluOauthUrl()

    #authenticated - get channel creds
    app.get '/authorize', @managementController.authorize
    app.get '/authorized', @managementController.authorized

    #setup message routes
    app.post '/received', @deviceController.received
    app.post '/config', @deviceController.config


    app.get '/', @managementController.authenticate

  getOctobluOauthUrl: =>
    return url.format
      protocol: 'https'
      host: 'oauth.octoblu.com'
      pathname: '/authorize'
      query:
        client_id: '206597a2-0883-4b3b-9b7c-93c3e0c05d62'
        redirect_uri: 'http://localhost:1337/authenticated'
        response_type: 'code'

module.exports = Router
