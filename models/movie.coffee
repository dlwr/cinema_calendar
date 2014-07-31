mongoose = require "mongoose"
findOrCreate = require "mongoose-findorcreate"
helper = require "./modelHelper"
Schema = mongoose.Schema
movieSchema = new Schema
  title: String
  release: Date
  length: Number
  staff: [Schema.Types.Mixed]
  summary: String
movieSchema.plugin = findOrCreate
movieSchema.pre "save", helper.updateDate
exports.movieSchema = movieSchema
Movie = mongoose.model "Movie", movieSchema
exports.Movie = Movie
