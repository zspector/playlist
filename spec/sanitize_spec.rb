require 'spec_helper'
require 'pry-debugger'

describe PL::SanitizeInput do
  it "should replace all apostrophes with double apostrophes" do
    input = {:name => "Zach's", artist: "Destiny's Child", song: "Boodylicious", id: 1}

    result = PL::SanitizeInput.run(input)
    expect(result[:name]).to eq("Zach''s")
    expect(result[:artist]).to eq("Destiny''s Child")
    expect(result[:song]).to eq("Boodylicious")
    expect(result[:id]).to eq(1)
  end
end
