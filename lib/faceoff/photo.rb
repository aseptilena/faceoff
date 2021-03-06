class Faceoff

  class Photo


    ##
    # Retrieve all 'Photos of Me'.

    def self.photos_of_me faceoff, options={}, &block
      agent = faceoff.agent
      start = options[:start] || 0

      index = start % 15

      param = "id=#{faceoff.profile_id}&v=photos&so=#{start}&ref=sgm"

      page = agent.get "/profile.php?#{param}"

      photo_id, options[:user_id] =
        page.body.scan(%r{/photo.php\?pid=(\d+)[^\\]+;id=(\d+)})[index]

      return unless photo_id

      retrieve_all faceoff,
                   photo_id,
                   options.merge(:album => "Photos of me"),
                   &block
    end


    ##
    # Retrieve all photos for a given album id. To retrieve the profile
    # album pass :profile as the album_id.

    def self.photos_of_album faceoff, album_id, options={}, &block
      agent = faceoff.agent
      start = options[:start] || 0

      options[:album] = "Profile pictures" if album_id == :profile

      param = album_id == :profile ? "profile=1" : "aid=#{album_id}"
      param = "#{param}&id=#{faceoff.profile_id}&s=#{start}"

      page = agent.get "/album.php?#{param}"
      photo_link = page.link_with(:href => %r{/photo.php}).href
      photo_id = $1 if photo_link =~ /pid=(\d+)/

      return unless photo_id

      retrieve_all faceoff, photo_id, options, &block
    end


    ##
    # Retrieve all photos in an album, starting at a given photo id.
    # Setting the 'global' argument to true will attempt to retrieve all
    # 'Photos of Me'.

    def self.retrieve_all faceoff, photo_id, options={}, &block
      agent  = faceoff.agent
      user_id = options[:user_id]
      limit  = options[:limit]

      param = "pid=#{photo_id}&id=#{user_id || faceoff.profile_id}"
      param = "#{param}&view=global&subj=#{faceoff.profile_id}" if user_id

      page = agent.get "/photo.php?#{param}"

      photo_count = ($1.to_i - 1) if page.body =~ /Photo \d+ of (\d+)/m
      photo_count = limit if limit && photo_count > limit

      photos = []

      photo_count.times do |i|
        url = page.search("img[@id='myphoto']").first['src']
        photo_id = $1 if page.uri.query =~ %r{pid=(\d+)}

        caption =
          page.search("div[@class='photocaption_text']").first.text rescue nil

        photos << new(photo_id, url, :caption => caption,
                                     :album => options[:album])

        yield photos.last if block_given?

        page = page.link_with(:text => 'Next').click
      end

      photos
    end


    # Facebook photo id.
    attr_accessor :fid

    # Url of the photo.
    attr_accessor :url

    # Caption of the photo.
    attr_accessor :caption

    # Album name (context) of the photo.
    attr_accessor :album


    def initialize id, url, options={}
      @fid     = id
      @url     = url
      @caption = options[:caption]
      @album   = options[:album] || "Photos"
    end


    ##
    # Saves the photo to the provided file path.

    def save! target=nil
      target ||= File.join ".", @album
      filename = File.join(target, "#{@fid}#{File.extname(@url)}")

      data = Faceoff.download(@url)

      Faceoff.safe_save(filename) do |file|
        file.write data
      end
    end
  end
end
