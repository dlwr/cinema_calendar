mongoose = require "mongoose"
findOrCreate = require "mongoose-findorcreate"
helper = require "./modelHelper"
Schema = mongoose.Schema
showSchema = new Schema
  theater: [{type:Schema.Types.ObjectId, ref: 'Theater'}]
  movie: [{type:Schema.Types.ObjectId, ref: 'Movie'}]
  start: Date
  end: Date
  remarks: String
showSchema.plugin findOrCreate
showSchema.pre "save", helper.updateDate
exports.showSchema = showSchema
Show = mongoose.model "Show", showSchema
exports.Show = Show
