module DjMon
  class DelayedJobsController < DjMon::ApplicationController
    layout nil

    def index
      @delayed_jobs = Delayed::Job.all
    end
  end
end