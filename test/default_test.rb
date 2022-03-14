# frozen_string_literal: true

require "test_helper"

class DefaultTest < Minitest::Test
  class Sparta; end 
  class Slavia; end
  class Dukla; end
  class Bohemians; end

  class Factory
    extend Toolcase::Registry
    register Dukla
    register Bohemians
    default Sparta
  end

  def test_default_retrieved
    assert_equal Sparta, Factory.find_by { |team| team == Slavia }
  end
end
