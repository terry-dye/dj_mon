module DjMon
  class DjReportsController < ActionController::Base
    respond_to :json
    layout 'dj_mon'
    
    before_filter :authenticate

    def index
    end

    def all
      respond_with reports_for(Delayed::Job.all)
    end

    def failed
      respond_with reports_for(Delayed::Job.where('delayed_jobs.failed_at IS NOT NULL'))
    end

    def active
      respond_with reports_for(Delayed::Job.where('delayed_jobs.locked_by IS NOT NULL'))
    end

    def queued
      respond_with reports_for(Delayed::Job.where('delayed_jobs.failed_at IS NULL AND delayed_jobs.locked_by IS NULL'))
    end

    protected
    
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == Rails.configuration.dj_mon.username &&
        password == Rails.configuration.dj_mon.password
      end
    end

    def reports_for jobs
      jobs.collect { |job| DjReport.new(job) }
    end

  end

end
