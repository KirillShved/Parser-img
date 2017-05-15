require 'pry'
require 'flickraw'
require 'open-uri'
require 'rmagick'

FlickRaw.api_key = '9ce4f8db4b2a189b79d79e1b88a7b504'
FlickRaw.shared_secret = '0a3c83e80245f931'
#
# include Magick
#
# binding.pry

class Main

  attr_reader :tag, :urls

  def initialize
    @tag = gets.chomp
  end

  def run
    puts 'Please enter one #tag or two and more #tags,'
    puts'separated by a comma (Expamle => cat, dog): '
    urls
    downloads
    collage
  end

  private

  def urls
    @urls = flickr.photos.search(tags: @tag, page: 1, per_page: 10).map(&:id)

    @urls = @urls.map { |id| flickr.photos.getInfo(photo_id: id) }

    @urls = @urls.map { |picture| FlickRaw.url_c(picture) }
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
    content = Magick::ImageList.new

    image = '0'
    10.times do
      content.read('../img/' + image + '.jpg')
      image.succ!
    end

    columns = 5
    rows = 2
    scale = 0.25

    collage = Magick::ImageList.new
    page = Magick::Rectangle.new(0, 0, 0, 0)
    content.scene = 0
    columns.times do |i|
      rows.times do |j|
        collage << content.scale(scale)
        page.x = i * collage.columns
        page.y = j * collage.rows
        collage.page = page
        (content.scene += 1) rescue content.scene = 0
      end
    end

    collage.mosaic.write('../img/collage.jpg')

    puts 'Collage create!'

    exit
  end
end

Main.new.run
