debug = require('debug')('meshblu:device-protocol-adapter-http')
MeshbluHttp = require 'meshblu-http'
url = require 'url'
_ = require 'lodash'

class CredentialsController
  constructor: ({@service}) ->

  authenticate: (req, res) =>
    console.log {user: req.user, cookie: req.cookies}
    res.cookie('meshblu_auth_bearer', req.user.bearerToken)
    res.redirect '/device/authorize'

  authorize: (req, res) =>
    console.log cookies: req.cookies
    console.log('omg, I am authenticated')
    console.log req.meshbluAuth
    editUrl = url.format
      host: "device-editor-octoblu.octoblu.dev/#{req.meshbluAuth.uuid}"
      query:
        token: req.meshbluAuth.token
        server: req.meshbluAuth.host
        port: req.meshbluAuth.port

    res.redirect editUrl

  authorized: (req, res) =>
    throw new Error('Implement authorized plz')

module.exports = CredentialsController
