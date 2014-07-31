config = require "config"
mongoose = require "mongoose"
connection = mongoose.connect "mongodb://#{config.mongodb.host}/#{config.mongodb.db}"
{Theater} = require "../models/theater"

request = require "request"
cheerio = require "cheerio"
async = require "async"

class TheaterPageScraper
  constructor: (@theater) ->
    @theaterUrl = @theater.url.eiga_dot_com
  run: (done) ->
    @finishCallback = done
    if @theaterUrl == ''
      console.log "Please input valid theater"
      @finishCallback()
    else
      @getTheaterInfo()
  getTheaterInfo: ->
    console.log "request", @theaterUrl
    request @theaterUrl
      , (err, resp, body) =>
        if !err && resp.statusCode == 200
          $ = cheerio.load body
          @parseTheaterInfo $
        else
          console.log "request failed", @theater.name, resp.statusCode, err
          @finishCallback()
  parseTheaterInfo: ($) ->
    console.log "parseTheaterInfo", @theater.name
    trs = $('#ciBox tr')
    trs.each (idx, tr) =>
      tr = $(tr)
      th_text = tr.find('th').text()
      td_text = tr.find('td').text()
      address_text = "所在地"
      if th_text.indexOf(address_text) >= 0
        @theater.address = td_text
    @theater.save =>
      @finishCallback()
  getShowInfo: ($) ->
    console.log "parseShowInfo", @theater.name
    scheduleLinks = $('#mBox .bt01 a')
  getScheduleInfo

Theater.find {}, (err, users) ->
  iterate = (theater, done) ->
    console.log '----'
    console.log theater.name
    client = new TheaterPageScraper theater
    client.run(done)
  finish = (err) ->
    mongoose.connection.close()
    process.exit()
  if !err
    async.eachSeries(users, iterate, finish)
