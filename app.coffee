express = require 'express'
methods = require './models/methods'
bodyParser = require 'body-parser'

app = express()

app.use express.Router()
app.use bodyParser.json()
app.set('port', (process.env.PORT || 3000))

listServices = (req, res, next) ->
    res.send 200, {'users': '/users', 'tasks': '/tasks'}
    return

app.get     '/',           listServices
app.get     '/users',      methods.findAllUsers
app.post    '/users',      methods.addUser
app.get     '/users/:_id', methods.findUser
app.put     '/users/:_id', methods.updateUser
app.delete  '/users/:_id', methods.deleteUser
app.delete  '/users',      methods.deleteAll

app.get     '/tasks',      methods.listTasks
app.post    '/tasks',      methods.addTask
app.get     '/tasks/:_id', methods.findTask
app.delete  '/tasks/:_id', methods.removeTask

server = app.listen app.get('port'), () ->
    console.log 'Listening on port %d', server.address().port
