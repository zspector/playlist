require 'pry-debugger'
module PL
  class CreateUser < Command
    # inputs = { username: 'bob', password: 123}
    def run(inputs)
      return failure(:input_blank) if inputs[:name] == "" || inputs[:password] == ""

      usernames = PL.db.get_user_by_name(inputs[:name])
      return failure(:name_taken) if usernames
      
      user = PL.db.create_user(inputs)
      return failure(:user_info_not_stored) if user.nil?
      
      success(:user => user)
    end
  end
end