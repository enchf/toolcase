# frozen_string_literal: true

require "test_helper"

class InheritanceTest < Minitest::Test
  class A; end
  class B; end
  class C; end
  class D; end
  class E; end
  class F; end

  class Factory
    extend Toolcase::Registry

    register A, tags: :one
    register B
    default C
  end

  class SubFactory < Factory
    register D, tags: :one
  end

  class SubSubFactory < SubFactory
    register E
    default F
  end

  def test_all_registries
    assert_equal [A, B], Factory.registries
    assert_equal [A, B, D], SubFactory.registries
    assert_equal [A, B, D, E], SubSubFactory.registries
  end

  def test_defaults
    assert_equal(C, Factory.find_by { false })
    assert_equal(C, SubFactory.find_by { false })
    assert_equal(F, SubSubFactory.find_by { false })
  end

  def test_tags
    assert_equal [A], Factory.registries(:one)
    assert_equal [A, D], SubFactory.registries(:one)
    assert_equal [A, D], SubSubFactory.registries(:one)
  end
end
