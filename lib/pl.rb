module PL
end

Dir["#{File.dirname(__FILE__)}/pl/*.rb"].each {|f| require(f)}
Dir["#{File.dirname(__FILE__)}/commands/*.rb"].each {|f| require(f)}
