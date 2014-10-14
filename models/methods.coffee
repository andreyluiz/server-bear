mongoose = require 'mongoose'
config = require '../config'
mongoose.connect config.database_uri
models = require('./models')(mongoose)

Task = models.Task;
User = models.User;

# Tasks
exports.listTasks = (req, res, next) ->
    return Task.find {}, (err, data) ->
        return res.status(500).send {message: 'An internal error has occured'} if err
        return res.status(200).send data

exports.addTask = (req, res, next) ->
    console.log 'entrou'
    contentType = req.headers['content-type']
    if not contentType || contentType != 'application/json'
        return res.status(400).send {message: 'Cannot add without content-type header'}
    console.log req.body
    task = req.body
    id = mongoose.Types.ObjectId(task.user_id)
    console.log id
    task.user_id = id
    User.find {_id: task.user_id }, (err, user) ->
        console.log task.user_id
        console.log 'entrou no find'
        return res.status(500).send {message: 'An internal error has occured'} if err
        return res.status(404).send {message: 'Related user not found'} if not user
        newTask = new Task req.body
        newTask.save (err) ->
            return res.status(500).send {message: 'An internal error has occured'} if err
            return res.status(201).send {location: "/tasks/" + newTask._id}

exports.findTask = (req, res) ->
    return Task.find { _id: req.params._id }, (err, task) ->
        return res.status(500).send {message: 'An internal error has occured'} if err
        return res.status(200).send task

exports.removeTask = (req, res, next) ->
    Task.findOne { _id: req.params._id }, (err, doc) ->
        return res.status(500).send {message: 'An internal error has occured'} if err
        return res.status(404).send {message: 'Task not found'} if not doc
        doc.remove()
        return res.status(202).send()

# Users
exports.findAllUsers = (req, res, next) ->
    return User.find {}, (err, users) ->
        return res.status(500).send {message: 'An internal error has occured'} if err
        return res.status(200).send users

exports.addUser = (req, res, next) ->
    contentType = req.headers['content-type']
    if not contentType || contentType != 'application/json'
        return res.status(400).send {message: 'Cannot add without content-type header.'}
    user = new User req.body
    user.save (err, newuser) ->
        return res.status(500).send {message: 'An internal error has occured'} if err
        return res.status(201).send {location: "/users/" + newuser._id}

exports.findUser = (req, res, next) ->
    return User.findOne { _id: req.params._id }, (err, user) ->
        return res.status(500).send {message: 'An internal error has occured'} if err
        return res.status(404).send {message: 'User not found'} if not user
        return res.status(200).send user

exports.updateUser = (req, res, next) ->
    contentType = req.headers['content-type']
    if not contentType || contentType != 'application/json'
        return res.status(400).send {message: 'Cannot add without content-type header.'}
    return User.findOne { _id: req.params._id }, (err, user) ->
        return res.status(500).send {message: 'An internal error has occured'} if err
        return res.status(404).send {message: 'User not found'} if not user 
        content = req.body
        user.fullname = content.fullname if content.fullname?
        user.username = content.username if content.username?
        user.email = content.email if content.email?
        user.password = content.password if content.password?
        user.active = content.active if content.active?
        user.save()
        return res.status(202).send user

exports.deleteUser = (req, res, next) ->
    User.findOne { _id: req.params._id }, (err, user) ->
        return res.status(500).send {message: 'An internal error has occured'} if err
        return res.status(404).send {message: 'User not found'} if not user
        user.remove()
        return res.status(202).send()

exports.deleteAll = (req, res) ->
    User.find {}, (err, users) ->
        if users.length > 0
            users.forEach (user) ->
                user.remove()
        return res.status(200).send()
