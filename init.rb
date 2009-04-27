require File.dirname(__FILE__) + '/lib/path_scrubber'

class String
  include PathScrubber::String
end
class Array
  include PathScrubber::Array
end