# frozen_string_literal: true

require "test_helper"

class SizeTest < Minitest::Test
  class Eco; end
  class Baricco; end
  class Calvino; end
  class Saviano; end

  class Factory
    extend Toolcase::Registry

    register Eco
    register Baricco
    default Calvino
  end

  def test_size
    assert_equal 2, Factory.size
    Factory.register Saviano
    assert_equal 3, Factory.size
  end
end
