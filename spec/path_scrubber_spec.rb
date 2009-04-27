require File.dirname(__FILE__) + '/spec_helper'

describe PathScrubber, ".set_scrubber" do

  it "should install itself in class" do
    PathScrubber::Scrubber.set_scrubber_style :some_style
    "henry is cool".respond_to?("scrub_as_some_style").should == true
    "henry is cool".respond_to?("scrub_as_other").should == false
  end

end

describe "PathScrubber String" do
  
  before do
    PathScrubber::Scrubber.set_scrubber_style :url
  end
  
  {
    "henry is cool" => "henry-is-cool",
    "CASE" => "case",
    ":re/?#[mo]@!v$e-'()*r+e,s;e=rved" => "remove-reserved"
  }.each do |k,v|
    it "#{k} should scrub to #{v}" do
      k.scrub_as_url.should == v
    end
  end
  
end

describe "PathScrubber Array" do
  
  before do
    PathScrubber::Scrubber.set_scrubber_style :url
  end
  
  {["henry is cool", "CASE"] => ["henry-is-cool", "case"]}.each do |k,v|
    it "#{k.inspect} should scrub to #{v.inspect}" do
      k.scrub_as_url.should == v
    end
  end
  
end

describe "PathScrubber Custom" do
  
  before do
    PathScrubber::Scrubber.set_scrubber_style :custom, :upcase => true
  end
  
  it "should have the correctly named method in there" do
    String.respond_to?("scrub_as_custom")
  end
  
  {
    "henry" => "HENRY"
  }.each do |k,v|
    it "#{k} should scrub to #{v}" do
      k.scrub_as_custom.should == v
    end
  end
  
  
end