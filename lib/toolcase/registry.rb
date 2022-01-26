# frozen_string_literal: true

module Toolcase
  # Registry mixin. Allows to convert a class into a registrable container.
  # It can then be used to register strategies/handlers and use the class as an abstract factory.
  module Registry
    def register(object = nil, id: nil, tag: :nil, &block)
      element = nil
      element = object unless object.nil?
      element = block if block_given?

      return if element.nil? || include?(element)

      elements << element
      tagged_elements[tag] << element
      identifiers[id] = element unless id.nil?

      element
    end

    def default(object = nil)
      @default = object unless object.nil?
      defined?(@default) ? @default : nil
    end

    def [](id)
      identifiers.fetch(id, default)
    end

    def find_by(tag = nil, &block)
      container(tag).find(-> { default }, &block)
    end

    def include?(object, tag = nil)
      container(tag).include?(object)
    end

    def size(tag = nil)
      container(tag).size
    end

    def replace(old_object_or_id, new_object)
      resolve_object_or_id(old_object_or_id) do |id, element|
        identifiers[id] = new_object unless id.nil?
        elements[elements.index(element)] = new_object

        tagged_list = find_in_tagged(element)
        tagged_list[tagged_list.index(element)] = new_object unless tagged_list.nil?
      end
    end

    def remove(object_or_id)
      resolve_object_or_id(object_or_id) do |id, element|
        identifiers.delete(id)
        elements.delete(element)
        find_in_tagged(element)&.delete(element)
      end
    end

    def clear(tag = nil)
      registries(tag).each { |object| remove(object) }
    end

    def inherited(child)
      super
      child.elements.concat(registries)
      child.tagged_elements.merge!(tagged_elements)
      child.identifiers.merge!(identifiers)
      child.default(default)
    end

    def registries(tag = nil)
      container(tag).clone.freeze
    end

    def tags
      tagged_elements.keys.reject { |key| key == :nil }
    end

    protected

    EMPTY = [].freeze

    def elements
      @elements ||= []
    end

    def resolve_object_or_id(obj_or_id)
      id = identifiers.key?(obj_or_id) ? obj_or_id : identifiers.find { |_, value| value == obj_or_id }&.first
      element = id.nil? ? obj_or_id : identifiers[id]
      return unless include?(element)

      yield(id, element)
    end

    def tagged_elements
      @tagged_elements ||= Hash.new { |hash, key| hash[key] = [] }
    end

    def find_in_tagged(element)
      tagged_elements.find { |_, list| list.include?(element) }&.last
    end

    def identifiers
      @identifiers ||= {}
    end

    def container(tag)
      return elements if tag.nil?

      tagged_elements.key?(tag) ? tagged_elements[tag] : EMPTY
    end
  end
end
