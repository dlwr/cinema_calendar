mongoose = require "mongoose"
findOrCreate = require "mongoose-findorcreate"
helper = require "./modelHelper"
Schema = mongoose.Schema
theaterSchema = new Schema
  name: String
  prefecture: String
  address: String
  phone: String
  url:
    eiga_dot_com: String
theaterSchema.plugin findOrCreate
theaterSchema.pre "save", helper.updateDate
exports.theaterSchema = theaterSchema
Theater = mongoose.model "Theater", theaterSchema
exports.Theater = Theater
