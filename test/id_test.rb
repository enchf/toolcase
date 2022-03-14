# frozen_string_literal: true

require "test_helper"

class IdTest < Minitest::Test
  class Ortega; end
  class EnzoPerez; end
  class Armani; end

  class Factory
    extend Toolcase::Registry
    register Ortega, id: :burrito
    register EnzoPerez
    register Armani
  end

  def test_retrieve_by_id
    assert_equal Ortega, Factory[:burrito]
    assert_nil Factory[:ramon]
  end
end
