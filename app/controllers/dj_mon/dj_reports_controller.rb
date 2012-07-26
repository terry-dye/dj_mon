module DjMon
  class DjReportsController < ActionController::Base
    respond_to :json
    layout 'dj_mon'
    
    before_filter :authenticate
    after_filter :set_api_version

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
    
    def settings
      respond_with DjReport.settings
    end
    
    def retry
      dj = Delayed::Job.find(params[:id])
      dj.update_attribute :failed_at, nil if dj
      redirect_to root_url, notice: "The job was been queued for a re-run" and return
    end
  
    def destroy
      dj = Delayed::Job.find(params[:id])
      dj.destroy if dj
      redirect_to root_url, notice: "The job was deleted" and return
    end
  
    protected

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == Rails.configuration.dj_mon.username &&
        password == Rails.configuration.dj_mon.password
      end
    end
    
    def set_api_version
      request.headers['dj_mon_version'] = '0.1.1'
    end

  end

end
