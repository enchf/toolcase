# frozen_string_literal: true

module Toolcase
  module Registry
    def register(object = nil, id: nil, tag: :default, &block)
      element = nil
      element = object unless object.nil?
      element = block if block_given?
      registries << element unless element.nil? || include?(element)
    end

    def default(object = nil)
    end

    def [](id)
    end

    def find_by(tag = nil, &block)
    end

    def include?(object)
    end

    def size
    end

    def replace(id, object)
    end

    def remove(id)
    end

    def inherited(child)
      super
      child.registries.concat(registries)
      child.default(default)
    end

    def registries(tag = nil)
      @registries ||= []
    end
  end
end
