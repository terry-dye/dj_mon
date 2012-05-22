module DjMon
  class DelayedJobsController < ActionController::Base
    layout 'dj_mon'

    def index
      @delayed_jobs = Delayed::Job.all
    end
  end
end