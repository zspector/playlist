require 'pry-debugger'

module PL
  module SanitizeInput
    def self.run(input)
      input.each_value do |value|
        if value.class == String
          value.gsub!("'", "''")
        end
      end
      return input
    end
  end
end
