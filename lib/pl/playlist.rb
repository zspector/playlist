class PL::Playlist
  attr_reader :id, :user_id
  attr_accessor :name
  def intialize(input)
    @id = input[:id]
    @user_id = input[:user_id]
    @name = input[:name]
  end
end
