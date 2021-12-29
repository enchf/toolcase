# frozen_string_literal: true

require "test_helper"

class RegistryTest < Minitest::Test
  # Classes used to be registered
  class Foo; end
  class Bar; end
  class Baz; end
  class Boo; end
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
    register Duh
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

  # Testing starts for read-only methods

  def test_methods_available
    methods = %i[register default [] find_by include? size replace remove registries]
    methods.each { |method| assert_respond_to Factory, method, "Method: #{method} on class" }
  end

  def test_registries_are_read_only
    assert_raises(FrozenError) { Factory.registries << 1 }
  end

  def test_default
    assert_equal Foo, Factory.default
    assert_equal Foo, Factory[:id]
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
    assert_equal Baz, FactoryWithIds[:bart]
    assert_equal Duh, FactoryWithIds[:homer]
    assert_equal Bar, FactoryWithIds[:moe]
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
    assert_equal 1, TaggedFactory.size(:other)
  end

  def test_registries
    assert_equal [Bar, Baz], Factory.registries
    refute_equal Factory.registries, OtherFactory.registries
  end

  def test_inheritance
    refute_equal Factory.default, SubFactory.default
    assert_equal [Bar, Baz, Duh], SubFactory.registries
    assert_equal(Boo, SubFactory.find_by { |handler| handler.name == 'Taz' })
  end

  def test_deeper_inheritance
    assert_equal SubFactory.default, SubSubFactory.default
    assert_equal [Bar, Baz, Duh, Foo], SubSubFactory.registries
    assert_equal(Boo, SubSubFactory.find_by { |handler| handler.name == 'Taz' })
    assert_equal(Bar, SubSubFactory.find_by { |handler| handler.name.end_with?('Bar') })
    assert_equal(Foo, SubSubFactory.find_by { |handler| handler.name.end_with?('Foo') })
  end

  def test_tagged_items
    assert_nil(TaggedFactory.find_by(:tagged) { |item| item == Foo })
    assert_nil(TaggedFactory.find_by(:tagged) { |item| item == Baz })
    assert_equal(Bar, TaggedFactory.find_by(:tagged) { |item| item == Bar })
    assert_equal [Bar, Boo], TaggedFactory.registries(:tagged)
  end

  def test_tags_are_inherited
    assert_nil(SubTaggedFactory.find_by(:other) { |item| item == Foo })
    assert_nil(SubTaggedFactory.find_by(:tagged) { |item| item == Baz })
    assert_equal(Bar, SubTaggedFactory.find_by(:tagged) { |item| item == Bar })
  end

  def test_can_register_blocks
    ExecutableFactory.registries.all? { |block| assert_respond_to block, :call }
    assert_equal 1, ExecutableFactory.registries.first.call(0)
    assert_equal '0', ExecutableFactory.registries.last.call(0)
  end
end
