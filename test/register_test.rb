# frozen_string_literal: true

require "test_helper"

class RegisterTest < Minitest::Test
  class Windows; end
  class Linux; end
  class MacOS; end
  class Solaris; end

  class Factory
    extend Toolcase::Registry
    register Windows
    register Linux
    register MacOS
    register { |_| :admit_blocks }
  end

  def test_register
    assert Factory.include?(Windows)
    assert Factory.include?(Linux)
    assert Factory.include?(MacOS)
    refute Factory.include?(Solaris)
  end

  def test_blocks
    assert :admit_blocks, Factory.find_by { |element| element.respond_to?(:call) }.call
  end
end
