class PL::User
  attr_reader :id, :name, :password
  def initialize(input)
    @id = input[:id]
    @name = input[:name]
    @password = input[:password]
  end
end
