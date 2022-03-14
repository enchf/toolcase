# frozen_string_literal: true

require "test_helper"

class ReplaceTest < Minitest::Test
  class Poborsky; end
  class Smicer; end
  class Nedved; end
  class Baros; end
  class Koller; end
  class Rosicky; end

  class Factory
    extend Toolcase::Registry

    register Poborsky, id: :steve
    register Koller, tags: :forward
    register Nedved
  end

  def test_replaced
    Factory.replace(Nedved, Rosicky)
    refute Factory.include?(Nedved)
    assert Factory.include?(Rosicky)
  end

  def test_replaced_by_id
    Factory.replace(:steve, Smicer)
    assert_equal Smicer, Factory[:steve]
    refute Factory.include?(Poborsky)
  end

  def test_replaced_with_tags
    Factory.replace(Koller, Baros)
    assert_equal [Baros], Factory.registries(:forward)
  end
end
