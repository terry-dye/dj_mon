ENV["RAILS_ENV"] = "test"
require 'shoulda'

require "config/environment.rb"

puts "Running tests for #{Delayed::Worker.backend}"

require "rails/test_help"
require File.expand_path('../../support/test_job', __FILE__)
require File.expand_path('../../support/failing_test_job', __FILE__)

Rails.backtrace_cleaner.remove_silencers!

