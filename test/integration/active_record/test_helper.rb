ENV["RAILS_ENV"] = "test"
require 'shoulda'

require_relative "../../dummy_active_record/config/environment.rb"
require "rails/test_help"

require_relative '../../support/test_job'
require_relative '../../support/failing_test_job'

Rails.backtrace_cleaner.remove_silencers!
