module.exports = (mongoose) ->
    Schema = mongoose.Schema;

    userSchema = mongoose.Schema
        id:       { type: Schema.Types.ObjectId },
        fullname: { type: String },
        username: { type: String },
        email:    { type: String },
        password: { type: String },
        date_add: { type: Date, default: Date.now },
        active:   { type: Boolean, default: true }

    taskSchema = mongoose.Schema
        id:             { type: Schema.Types.ObjectId },
        description:    { type: String },
        done:           { type: Boolean, default: false },
        user_id:        { type: Schema.Types.ObjectId }

    models = {
        Task: mongoose.model('tasks', taskSchema),
        User: mongoose.model('users', userSchema)
    }

    return models;
