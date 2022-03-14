# frozen_string_literal: true

require "test_helper"

class RegistriesTest < Minitest::Test
  class Homer; end
  class Barney; end
  class Apu; end
  class Burns; end
  class Flanders; end

  class Factory
    extend Toolcase::Registry

    register Homer, tags: %i[employee drinker]
    register Barney, tags: :drinker
    register Apu, tags: %i[employer religious]
    register Burns, tags: :employer
    register Flanders, tags: %i[employer religious]
  end

  def test_all_registries
    assert_equal [Homer, Barney, Apu, Burns, Flanders], Factory.registries
  end

  def test_subsets
    assert_equal [Homer, Barney], Factory.registries(:drinker)
    assert_equal [Apu, Burns, Flanders], Factory.registries(:employer)
    assert_equal [Homer], Factory.registries(:employee)
    assert_equal [Apu, Flanders], Factory.registries(:religious)
  end
end
