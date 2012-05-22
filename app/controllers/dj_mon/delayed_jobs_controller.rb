module DjMon
  class DelayedJobsController < DjMon::ApplicationController
    def index
      @delayed_jobs = Delayed::Job.all
    end
  end
end