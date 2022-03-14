# frozen_string_literal: true

require "test_helper"

class IncludeTest < Minitest::Test
  class Bender; end
  class Fry; end
  class Leela; end
  class Professor; end

  class Factory
    extend Toolcase::Registry
    register Professor, tags: :human
    register Fry, tags: :human
    register Bender
  end

  def test_include
    assert Factory.include?(Professor)
    refute Factory.include?(Leela)
  end

  def test_include_in_set
    assert Factory.include?(Fry, :human)
    refute Factory.include?(Bender, :human)
  end
end
