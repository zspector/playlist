class PL::Playlist
  attr_reader :id, :username
  attr_accessor :name
  def initialize(input)
    @id = input[:id]
    @username = input[:username]
    @name = input[:name]
  end
end
