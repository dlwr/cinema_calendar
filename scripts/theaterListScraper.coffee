config = require "config"
mongoose = require "mongoose"
connection = mongoose.connect "mongodb://#{config.mongodb.host}/#{config.mongodb.db}"
{Theater} = require "../models/theater"

request = require "request"
cheerio = require "cheerio"
async = require "async"

class TheaterListScraper
  constructor: () ->
    @listUrl = "http://eiga.com/theater/13/"
  run: () ->
    @getTheaterList()
  getTheaterList: ->
    console.log "request", @listUrl
    request @listUrl
      , (err, resp, body) =>
        if !err && resp.statusCode == 200
          $ = cheerio.load body
          @parseTheaterList $
        else
          console.log "request failed"
          exit()
  parseTheaterList: ($) ->
    saveOneTheaterLink = (link, done) =>
      data =
        name: link.children[0].data
        prefecture: '東京都'
        url:
          eiga_dot_com: 'http://eiga.com' + link.attribs.href
      Theater.findOrCreate {'url.eiga_dot_com':data.url.eiga_dot_com}, (err, theater, created) =>
        if !created
          done()
        theater.name = data.name
        theater.prefecture = data.prefecture
        theater.url.eiga_dot_com = data.url.eiga_dot_com
        theater.save(done)
    iterate = (link, done) ->
      saveOneTheaterLink(link, done)
    finish = (err) ->
      console.log "finish"
      mongoose.connection.close()
      process.exit()
    console.log "parseTheaterList"
    theaterAnchors = $('#pref_theaters ul li a')
    if theaterAnchors.length
      async.eachSeries(theaterAnchors, iterate, finish)

scraper = new TheaterListScraper
scraper.run()

