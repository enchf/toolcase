# frozen_string_literal: true

module Toolcase
  module Registry
    def register(object, id: nil, tag: :default)
    end

    def default(object)
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
      child.registries.merge!(registries)
      child.default(default)
    end

    def registries(tag = nil)
      @registries ||= {}
    end
  end
end
