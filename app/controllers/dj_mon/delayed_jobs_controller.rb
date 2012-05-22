module DjMon
  class DelayedJobsController < ActionController::Base
    respond_to :json
    layout 'dj_mon'

    def index
      @delayed_jobs = []
    end

    def all
      respond_with Delayed::Job.all
    end

    def failed
      respond_with Delayed::Job.where('delayed_jobs.failed_at IS NOT NULL')
    end

    def active
      respond_with Delayed::Job.where('delayed_jobs.locked_by IS NOT NULL')
    end

    def queued
      respond_with Delayed::Job.where('delayed_jobs.failed_at IS NULL AND delayed_jobs.locked_by IS NULL')
    end
  end
end
