module DjMon
  class DelayedJobsController < DjMon::ApplicationController
    def index
      @delayed_jobs = Delayed::Jobs.all
    end
  end
end