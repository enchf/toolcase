# frozen_string_literal: true

require "test_helper"

class RegistryTest < Minitest::Test
  # Classes used to be registered
  class Foo; end
  class Bar; end
  class Baz; end
  class Boo; end
  class Woo; end
  class Duh; end

  # Sample factories
  class Factory
    extend Toolcase::Registry
    default Foo
    register Bar
    register Baz
  end

  class OtherFactory
    extend Toolcase::Registry
    register Boo
  end

  class SubFactory < Factory
    default Boo
    register Woo
  end

  class SubSubFactory < SubFactory
    register Foo
  end

  class TaggedFactory
    extend Toolcase::Registry
    register Foo
    register Bar, tag: :tagged
    register Baz, tag: :other
    register Boo, tag: :tagged
    register Woo
  end

  class FactoryWithIds
    extend Toolcase::Registry
    register Duh, id: :homer
    register Foo
    register Bar, id: :moe
    default Baz
  end

  class SubFactoryWithIds < FactoryWithIds; end
  class SubTaggedFactory < TaggedFactory; end

  class ExecutableFactory
    extend Toolcase::Registry
    register { |i| i + 1 }
    register(&:to_s)
  end

  # Testing starts

  def test_methods_available
    methods = %i[register default [] find_by include? size replace remove registries]
    methods.each { |method| assert_respond_to A, method, "Method: #{method} on class" }
  end

  def test_register
    Factory.register(Duh)
    assert Factory.include?(Duh)
  end

  def test_avoid_duplicates
    Factory.register(Bar)
    assert_equal 2, Factory.registries
    assert_equal [Bar, Baz], Factory.registries
  end

  def test_default
    assert_equals Foo, Factory.default
    assert_equals Foo, Factory[:id]
    assert_equals(Foo, Factory.find_by { |handler| handler == Duh })
    assert_nil OtherFactory.default
    assert_nil OtherFactory[:id]
    assert_nil(OtherFactory.find_by { |handler| handler == Duh })
  end

  def test_find_by
    found = Factory.find_by { |handler| handler.name.end_with?('Baz') }
    assert_equal Baz, found
  end

  def test_get
    assert_equals Baz, FactoryWithIds[:bart]
    assert_equals Duh, FactoryWithIds[:homer]
    assert_equals Bar, FactoryWithIds[:moe]
    assert_nil TaggedFactory[:homer]
  end

  def test_include?
    assert OtherFactory.include?(Boo)
    refute OtherFactory.include?(Bar)
  end

  def test_size
    assert_equal 2, Factory.size
    assert_equal 3, SubFactory.size
    assert_equal 4, SubSubFactory.size
  end

  def test_replace
    assert_equal Bar, FactoryWithIds[:moe]
    FactoryWithIds.replace(:moe, Boo)
    assert_equal Boo, FactoryWithIds[:moe]

    Factory.replace(Bar, Duh)
    assert_equal [Duh, Baz], Factory.registries
  end

  def test_remove
    FactoryWithIds.remove(:moe)
    assert_equal Baz, FactoryWithIds[:moe]

    Factory.remove(Baz)
    assert_equal [Bar], Factory.registries
  end

  def test_alter_after_inheritance
    SubFactoryWithIds.replace(:homer, Woo)
    SubFactoryWithIds.remove(Foo)

    assert_equal Woo, SubFactoryWithIds[:homer]
    refute SubFactoryWithIds.include?(Foo)
  end

  def test_registries
    assert_equal [Bar, Baz], Factory.registries
    refute_equal Factory.registries, OtherFactory.registries
  end

  def test_inheritance
    refute_equal Factory.default, SubFactory.default
    assert_equal [Bar, Baz, Woo], SubFactory.registries
    assert_equal(Boo, SubFactory.find_by { |handler| handler.name == 'Taz' })
  end

  def test_deeper_inheritance
    assert_equal SubFactory.default, SubSubFactory.default
    assert_equal [Bar, Baz, Woo, Foo], SubSubFactory.registries
    assert_equal(Boo, SubSubFactory.find_by { |handler| handler.name == 'Taz' })
    assert_equal(Bar, SubSubFactory.find_by { |handler| handler.name.end_with?('Bar') })
    assert_equal(Foo, SubSubFactory.find_by { |handler| handler.name.end_with?('Foo') })
  end

  def test_tagged_items
    assert_nil(TaggedFactory.find_by(:tagged) { |item| item == Foo })
    assert_nil(TaggedFactory.find_by(:tagged) { |item| item == Baz })
    assert_equal(Bar, TaggedFactory.find_by(:tagged) { |item| item == Bar })
  end

  def test_tags_are_inherited
    assert_nil(SubTaggedFactory.find_by(:other) { |item| item == Foo })
    assert_nil(SubTaggedFactory.find_by(:tagged) { |item| item == Baz })
    assert_equal(Bar, SubTaggedFactory.find_by(:tagged) { |item| item == Bar })
  end

  def test_can_register_blocks
    ExecutableFactory.registries.all? { |block| assert_respond_to block, :call }
    assert_equals 1, ExecutableFactory.first.call(0)
    assert_equals '0', ExecutableFactory.last.call(0)
  end
end
