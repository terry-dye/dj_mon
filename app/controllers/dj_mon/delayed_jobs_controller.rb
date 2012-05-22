module DjMon
  class DelayedJobsController < DjMon::ApplicationController
    layout 'dj_mon'

    def index
      @delayed_jobs = Delayed::Job.all
    end
  end
end