# frozen_string_literal: true

require "test_helper"

# Testing mutable methods
class RegistryModificationsTest < Minitest::Test
  class Bart; end
  class Lisa; end
  class Maggie; end
  class Hugo; end
  class Milhouse; end

  def setup
    @factory = Class.new
    @factory.extend(Toolcase::Registry)
  end

  def test_register
    @factory.register(Bart)
    assert @factory.include?(Bart)
    assert_equal [Bart], @factory.registries
  end

  def test_avoid_duplicates
    @factory.register(Bart)
    @factory.register(Lisa)
    @factory.register(Bart)

    assert_equal 2, @factory.registries
    assert_equal [Bart, Lisa], @factory.registries
  end

  def test_replace
    @factory.register Lisa, id: :last_daughter, tag: :females
    assert_equal Lisa, @factory[:last_daughter]
    
    @factory.replace(:last_daughter, Maggie)
    assert_equal Maggie, @factory[:last_daughter]

    @factory.replace(Bart, Lisa)
    assert_equal [Maggie], @factory.registries
    assert_equal [Maggie], @factory.registries(:females)

    @factory.replace(Maggie, Lisa)
    assert_equal [Lisa], @factory.registries
    assert_equal [Lisa], @factory.registries(:females)
    assert_equal Lisa, @factory[:last_daughter]
  end

  def test_remove
    @factory.register Bart, id: :son, tag: :males
    @factory.register Lisa, id: :daughter, tag: :females

    assert_equal [Bart, Lisa], @factory.registries

    @factory.remove(Bart)
    assert_equal [Lisa], @factory.registries
    assert_equal [], @factory.registries(:males)
    assert_equal [Lisa], @factory.registries(:females)
    assert_nil @factory[:son]

    @factory.remove(:daughter)
    assert_equal [], @factory.registries
    assert_equal [], @factory.registries(:males)
    assert_equal [], @factory.registries(:females)
    assert_nil @factory[:daughter]
  end

  def test_alter_after_inheritance
    @factory.register Bart, tag: :children, id: :bad
    @factory.register Hugo, tag: :children, id: :good
    @factory.register Maggie
    @factory.default Milhouse

    subTestFactory = Class.new(@factory)

    assert_equal Milhouse, subTestFactory[:baby]

    subTestFactory.replace(:good, Lisa)
    assert_equal [Bart, Lisa, Maggie], subTestFactory.registries
    assert_equal [Bart, Lisa], subTestFactory.registries(:children)

    subTestFactory.remove(Maggie)
    assert_equal [Bart, Lisa], subTestFactory.registries
    assert_equal [Bart, Lisa], subTestFactory.registries(:children)
    refute subTestFactory.include?(Maggie)

    subTestFactory.remove(:bad)
    assert_equal [Lisa], subTestFactory.registries
    assert_equal [Lisa], subTestFactory.registries(:children)
  end
end
