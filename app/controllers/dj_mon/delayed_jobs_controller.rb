module DjMon
  class DelayedJobsController < RailsBlogEngine::ApplicationController
    def index
      @delayed_jobs = Delayed::Jobs.all
    end
  end
end