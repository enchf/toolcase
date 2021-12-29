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

      registries << element
      tagged[tag] << element
      identifiers[id] = element unless id.nil?
    end

    def default(object = nil); end

    def [](id); end

    def find_by(tag = nil, &block); end

    def include?(object); end

    def size
      registries.size
    end

    def replace(id, object); end

    def remove(id); end

    def inherited(child)
      super
      child.registries.concat(registries)
      child.default(default)
    end

    def registries(tag = nil)
      @registries ||= []
      tag.nil? ? @registries : tagged[tag]
    end

    private

    def tagged
      @tagged ||= Hash.new { |hash, key| hash[key] = [] }
    end

    def identifiers
      @identifiers ||= {}
    end
  end
end
