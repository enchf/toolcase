# frozen_string_literal: true

require "test_helper"

class IdTest < Minitest::Test
  class Ortega; end
  class Gallardo; end
  class EnzoPerez; end
  class Armani; end

  class Factory
    extend Toolcase::Registry
    register Ortega, id: :burrito
    register Gallardo, id: :muñeco
    register EnzoPerez
    register Armani
  end

  def test_retrieve_by_id
    assert_equal Ortega, Factory[:burrito]
    assert_nil Factory[:ramon]
  end

  def test_all_ids
    %i[burrito muñeco].each do |id|
      assert Factory.identifiers.include?(id)
    end
  end
end
