# frozen_string_literal: true

require "test_helper"

class ClearTest < Minitest::Test
  class Pavic; end
  class Petrovic; end
  class Kis; end
  class Carrere; end
  class Houellebecq; end
  class Grass; end

  class Factory
    extend Toolcase::Registry

    register Pavic, tags: :serbian
    register Petrovic, tags: :serbian
    register Kis, tags: :serbian
    register Carrere, tags: :french
    register Houellebecq, tags: :french
    register Grass, tags: :german
  end

  def test_clear
    Factory.clear(:french)
    assert_equal [Pavic, Petrovic, Kis, Grass], Factory.registries

    Factory.clear
    assert_equal [], Factory.registries
  end
end
