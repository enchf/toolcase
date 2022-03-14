# frozen_string_literal: true

require "test_helper"

class TagsTest < Minitest::Test
  class Bart; end
  class Lisa; end
  class Maggie; end
  class Hugo; end
  class Nelson; end

  class Factory
    extend Toolcase::Registry
    register Bart, tags: %i[male family]
    register Lisa, tags: %i[female family]
    register Maggie, tags: %i[female family]
    register Nelson, tags: %i[male]
    default Hugo
  end

  def test_tagged_sets
    assert_equal [Bart, Nelson], Factory.registries(:male)
    assert_equal [Lisa, Maggie], Factory.registries(:female)
    assert_equal [Bart, Lisa, Maggie], Factory.registries(:family)
  end

  def test_tagged_filtering
    assert_equal Lisa, Factory.find_by(:female) { |character| character.name.include?('L') }
    assert_equal Hugo, Factory.find_by(:family) { |character| character.name.include?('Nelson') }
  end

  def test_default_retrieved_from_empty_tagged_set
    assert_equal Hugo, Factory.find_by(:male) { |_| false }
  end

  def test_retrieve_all_tags
    assert_equal %i[male family female], Factory.tags
  end
end
