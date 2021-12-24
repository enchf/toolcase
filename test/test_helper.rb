# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "toolcase"
require "byebug"

require "minitest/autorun"
require 'minitest/unit'
require "minitest/reporters"

require 'mocha/minitest'

Minitest::Reporters.use!
