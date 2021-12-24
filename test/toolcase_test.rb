# frozen_string_literal: true

require "test_helper"

class ToolcaseTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Toolcase::VERSION
  end
end
