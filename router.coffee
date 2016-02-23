url                   = require 'url'
passport              = require 'passport'
MeshbluAuth           = require 'express-meshblu-auth'
DeviceController      = require './src/controllers/device-controller'
CredentialsController = require './src/controllers/credentials-controller'
OctobluStrategy       = require 'passport-octoblu'

class Router
  constructor: ({service, @meshbluConfig}, dependencies={}) ->
    @deviceController      = new DeviceController {service}
    @credentialsController = new CredentialsController {service}

  route: (app) =>
    app.use passport.initialize()
    app.use passport.session()
    @setupOctobluOauth clientID: '206597a2-0883-4b3b-9b7c-93c3e0c05d62', clientSecret: '1efc628ff1899366622f889610455ce0714bcd96'

    app.get '/octoblu/authenticate', passport.authenticate('octoblu'), @credentialsController.authenticate

    meshbluAuth = MeshbluAuth @meshbluConfig, errorCallback: (error, {req, res}) =>
      console.log 'unauthorized. redirecting.'
      res.redirect '/octoblu/authenticate'

    app.use meshbluAuth
    app.get '/device/authorize', @credentialsController.authorize
    app.get '/device/authorized', @credentialsController.authorized

    app.post '/events/received', @deviceController.received
    app.post '/events/config', @deviceController.config

  setupOctobluOauth: ({clientID, clientSecret}) =>    
    octobluStrategyConfig =
      clientID: clientID
      clientSecret: clientSecret
      callbackURL: 'http://localhost:1337/octoblu/authenticate'
      passReqToCallback: true

    passport.use new OctobluStrategy octobluStrategyConfig, (req, bearerToken, secret, {uuid}, next) =>
      next null, {uuid, bearerToken}

    passport.serializeUser (user, done) => done null, user
    passport.deserializeUser (user, done) => done null, user

module.exports = Router
