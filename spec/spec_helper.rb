require 'pry'
require './lib/pl.rb'
include PL

RSpec.configure do |config|
  config.before(:each) do
    PL.instance_variable_set(:@__db_instance, nil)
  end
end
