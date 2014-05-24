require 'ostruct'

module PL
  class Command
    def self.run(input)
      self.new.run(input)
    end


    def self.add(input)
      self.new.add(input)
    end

    def self.get(input)
      self.new.get(input)
    end

    def self.delete(input)
      self.new.delete(input)
    end

    def self.edit(input)
      self.new.edit(input)
    end

    def failure(error_sym, data={})
      CommandFailure.new(data.merge :error => error_sym)
    end

    def success(data={})
      CommandSuccess.new(data)
    end
  end

  class CommandFailure < OpenStruct
    def success?
      false
    end
  end

  class CommandSuccess < OpenStruct
    def success?
      true
    end
  end
end
