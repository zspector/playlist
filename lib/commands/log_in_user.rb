module PL
  class LogInUser < Command
    # inputs = { username: 'bob', password: 123}
    def run(inputs)
      # validate: user exists?

      user = PL.db.get_user_by_name(inputs[:name])
      return failure(:user_name_does_not_exist) if user.nil?

      if user.password != inputs[:password] || user.name != inputs[:name]
        return failure(:invalid_user_or_password)
      end
      success(:user => user)
    end
  end
end