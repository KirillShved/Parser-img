require 'pry'
require 'flickraw'
require 'open-uri'
require 'rmagick'

FlickRaw.api_key = "9ce4f8db4b2a189b79d79e1b88a7b504"
FlickRaw.shared_secret = "0a3c83e80245f931"

class Main

  attr_reader :tag, :urls

  def initialize
    @tag = ''
    @urls = []
  end

  def run
    urls
    puts @urls
  end

  private

  def urls
    @tag = gets.chomp

    @urls = flickr.photos.search(tags: @tag, page: 1, per_page: 10).map(&:id) # map { |element| element.id }

    @urls = @urls.map { |id| flickr.photos.getInfo(photo_id: id) }

    @urls = @urls.map { |picture| FlickRaw.url(picture) }
  end
end

Main.new.run
