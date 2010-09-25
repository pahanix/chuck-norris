require 'helper'

class TestChuckNorris < Test::Unit::TestCase
  should "throw exception and say boom" do
    begin
      raise StandardError
    rescue
    end
  end
  
  should "throw String exception and say boom" do
    begin
      raise "String"
    rescue
    end
  end
  
end
