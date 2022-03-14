# frozen_string_literal: true

require "test_helper"

class RemoveTest < Minitest::Test
  class Mario; end
  class Luigi; end
  class Wario; end
  class Toad; end

  class Factory
    extend Toolcase::Registry

    register Mario, tags: :good, id: :mario
    register Luigi, tags: :good
    register Wario, tags: :bad
    register Toad, tags: :good, id: :honguito
  end

  def test_remove
    Factory.remove(:mario)
    Factory.remove(Wario)

    assert_equal [Luigi, Toad], Factory.registries(:good)
    assert_equal [], Factory.registries(:bad)

    assert_nil Factory[:mario]

    refute Factory.include?(Mario)
    refute Factory.include?(Wario)
  end
end
