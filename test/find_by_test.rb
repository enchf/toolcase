# frozen_string_literal: true

require "test_helper"

class FindByTest < Minitest::Test
  class River; end
  class SanLorenzo; end
  class Estudiantes; end
  class Gimnasia; end
  class Huracan; end

  class Factory
    extend Toolcase::Registry
    register River, tags: :bsas
    register SanLorenzo, tags: :bsas
    register Gimnasia, tags: :lp
    default Huracan
  end

  def test_find_by
    assert_equal River, Factory.find_by { |team| team.name.include?('River') }
  end

  def test_return_default
    assert_equal Huracan, Factory.find_by { |team| team.name.include?('Estudiantes') }
  end

  def test_find_in_set
    assert_equal River, Factory.find_by(:bsas) { |team| team.name.include?('River') }
    assert_equal Huracan, Factory.find_by(:lp) { |team| team.name.include?('River') }
  end
end
