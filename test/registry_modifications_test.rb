# frozen_string_literal: true

require "test_helper"

# Testing mutable methods
class RegistryModificationsTest < Minitest::Test
  class Bart; end
  class Lisa; end
  class Maggie; end
  class Hugo; end
  class Milhouse; end
  class Nelson; end

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
    [Bart, Lisa, Bart].each { |element| @factory.register element }

    assert_equal 2, @factory.size
    assert_equal [Bart, Lisa], @factory.registries
  end

  def test_replace_by_id
    @factory.register Lisa, id: :last_daughter, tag: :females
    assert_equal Lisa, @factory[:last_daughter]

    @factory.replace(:last_daughter, Maggie)
    assert_equal Maggie, @factory[:last_daughter]
  end

  def test_replace_by_value
    @factory.register Hugo, tag: :sons
    @factory.register Milhouse, id: :friend

    @factory.replace(Hugo, Bart)
    assert_equal [Bart, Milhouse], @factory.registries
    assert_equal [Bart], @factory.registries(:sons)

    @factory.replace(Milhouse, Nelson)
    assert_equal [Bart, Nelson], @factory.registries
    assert_equal [Bart], @factory.registries(:sons)
    assert_equal Nelson, @factory[:friend]
  end

  def test_remove_by_id
    @factory.register Bart, id: :son, tag: :males
    @factory.register Lisa, id: :daughter, tag: :females

    assert_equal [Bart, Lisa], @factory.registries

    @factory.remove(:daughter)
    assert_equal [Bart], @factory.registries
    assert_equal [Bart], @factory.registries(:males)
    assert_equal [], @factory.registries(:females)
    assert_nil @factory[:daughter]
  end

  def test_remove_by_value
    @factory.register Bart, id: :son, tag: :males
    @factory.register Lisa, id: :daughter, tag: :females

    @factory.remove(Bart)
    assert_equal [Lisa], @factory.registries
    assert_equal [], @factory.registries(:males)
    assert_equal [Lisa], @factory.registries(:females)
    assert_nil @factory[:son]
  end

  def test_replace_in_inheritance
    @factory.register Bart, tag: :children, id: :bad
    @factory.register Hugo, tag: :children, id: :good
    @factory.register Nelson
    @factory.default Milhouse

    sub_factory = Class.new(@factory)

    assert_equal Milhouse, sub_factory[:friend]

    sub_factory.replace(:good, Lisa)
    assert_equal [Bart, Lisa, Nelson], sub_factory.registries
    assert_equal [Bart, Lisa], sub_factory.registries(:children)
  end

  def test_remove_in_inheritance
    @factory.register Bart, tag: :children, id: :bad
    @factory.register Lisa, tag: :children, id: :good
    @factory.register Milhouse

    sub_factory = Class.new(@factory)

    sub_factory.remove(Milhouse)
    assert_equal [Bart, Lisa], sub_factory.registries
    assert_equal [Bart, Lisa], sub_factory.registries(:children)
    refute sub_factory.include?(Milhouse)

    sub_factory.remove(:bad)
    assert_equal [Lisa], sub_factory.registries
    assert_equal [Lisa], sub_factory.registries(:children)
    assert_nil sub_factory[:bad]
  end

  def test_clear
    register_all
    @factory.clear

    [[], [:males], [:females]].each { |args| assert @factory.registries(*args).empty? }
    [@factory[:son], @factory[:first_daughter]].each { |element| refute element }
  end

  def test_clear_tagged
    register_all
    @factory.clear(:males)

    assert @factory.registries(:males).empty?
    [[], [:females]].each { |args| refute @factory.registries(*args).empty? }

    refute @factory[:son]
    assert @factory[:first_daughter]
  end

  private

  def register_all
    @factory.register Bart, id: :son, tag: :males
    @factory.register Nelson, tag: :males
    @factory.register Lisa, id: :first_daughter, tag: :females
    @factory.register Maggie, tag: :females
    @factory.register Hugo
    @factory.register Milhouse
  end
end
