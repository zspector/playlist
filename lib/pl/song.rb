class PL::Song
  attr_reader :id, :playlist_id
  attr_accessor :artist, :name, :url
  def intialize(input)
    @id = input[:id]
    @playlist_id = input[:playlist_id]
    @artist = input[:artist]
    @name = input[:name]
    @url = input[:url]
  end
end
