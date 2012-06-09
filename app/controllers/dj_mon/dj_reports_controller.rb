module DjMon
  class DjReportsController < ActionController::Base
    respond_to :json
    layout 'dj_mon'
    
    before_filter :authenticate

    def index
    end

    def all
      respond_with DjReport.all_reports
    end

    def failed
      respond_with DjReport.failed_reports
    end

    def active
      respond_with DjReport.active_reports
    end

    def queued
      respond_with DjReport.queued_reports
    end
    
    def dj_counts
      respond_with DjReport.dj_counts
    end

    protected

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == Rails.configuration.dj_mon.username &&
        password == Rails.configuration.dj_mon.password
      end
    end
  end

end
