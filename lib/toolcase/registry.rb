# frozen_string_literal: true

require 'securerandom'

module Toolcase
  # Registry mixin. Allows to convert a class into a registrable container.
  # It can then be used to register strategies/handlers and use the class as an abstract factory.
  module Registry
    def register(object = nil, id: default_id, tags: EMPTY, &block)
      return if container.key?(id)

      element = nil
      element = object unless object.nil?
      element = block if block_given?

      tags = tags.is_a?(Array) ? tags : [tags]

      container[id] = [element, Set.new(tags)]
    end

    def default(object = nil)
      @default = object unless object.nil?
      defined?(@default) ? @default : nil
    end

    def [](id)
      container.key?(id) ? container[id].first : default
    end

    def find_by(tag = nil, &block)
      subset(tag).find(-> { default }, &block)
    end

    def include?(object, tag = nil)
      subset(tag).include?(object)
    end

    def size(tag = nil)
      subset(tag).size
    end

    def replace(old, new_object)
      object_or_id(old) do |id|
        old_tuple = container[id]
        container[id] = [new_object, old_tuple.last]
      end
    end

    def remove(value_or_id)
      object_or_id(value_or_id) do |id|
        container.delete(id)
      end
    end

    def clear(tag = nil)
      subset(tag).each { |object| remove(object) }
    end

    def inherited(child)
      super
      child.container.merge!(container)
      child.default(default)
    end

    def registries(tag = nil)
      subset(tag)
    end

    def tags
      container.values.flat_map { |_, tags| tags.to_a }.uniq
    end

    protected

    EMPTY = [].freeze

    def container
      @container ||= {}
    end

    def subset(tag)
      container.values.select do |_, tags|
        tag.nil? || tags.include?(tag)
      end.map(&:first)
    end

    def object_or_id(obj_or_id)
      id = container.key?(obj_or_id) ? obj_or_id : container.find { |_, (value, _)| value == obj_or_id }&.first

      yield(id) unless id.nil?
    end

    def default_id
      SecureRandom.uuid
    end
  end
end
