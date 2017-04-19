require 'pry'
require 'flickraw'
require 'open-uri'
require 'rmagick'

FlickRaw.api_key = '9ce4f8db4b2a189b79d79e1b88a7b504'
FlickRaw.shared_secret = '0a3c83e80245f931'

class Main

  attr_reader :tag, :urls

  def initialize
    @tag = ''
    @urls = []
  end

  def run
    print 'Please enter a #tag: '
    urls
    downloads
    collage
  end

  private

  def urls
    @tag = gets.chomp

    @urls = flickr.photos.search(tags: @tag, page: 1, per_page: 10).map(&:id) # map { |element| element.id }

    @urls = @urls.map { |id| flickr.photos.getInfo(photo_id: id) }

    @urls = @urls.map { |picture| FlickRaw.url(picture) }
  end

  def downloads
    @urls.each_with_index do |image, index|
      open(image) do |f|
        File.open('../img/' + index.to_s + '.jpg', 'wb') do |file|
          file.puts f.read
        end
      end
    end
  end

  def collage
    a = Magick::ImageList.new

    image = '0'
    10.times do
      a.read('../img/' + image + '.jpg')
      image.succ!
    end

    collage = Magick::ImageList.new
    page = Magick::Rectangle.new(0, 0, 0, 0)
    a.scene = 0
    5.times do |i|
      2.times do |j|
        collage << a.scale(0.25)
        page.x = j * collage.columns
        page.y = i * collage.rows
        collage.page = page
        (a.scene += 1) rescue a.scene = 0
      end
    end

    collage.mosaic.write('../img/collage.jpg')

    exit
  end
end

Main.new.run
