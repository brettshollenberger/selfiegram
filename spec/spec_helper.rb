require "rspec"
require "pry"

Dir[File.expand_path(File.join(__FILE__, "../../lib/**/*.rb"))].each  { |f| require f }
Dir[File.expand_path(File.join(__FILE__, "../../spec/**/*.rb"))].each { |f| require f }
