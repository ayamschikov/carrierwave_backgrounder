# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'logger'
require 'carrierwave_backgrounder'

module WarningSuppression
  def suppress_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    result
  end
end

RSpec.configure do |c|
  c.include WarningSuppression
end
