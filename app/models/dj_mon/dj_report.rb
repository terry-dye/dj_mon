module DjMon
  class DjReport
    attr_accessor :delayed_job
    
    def initialize delayed_job
      self.delayed_job = delayed_job
    end

    def as_json(options={})
      { 
        id: delayed_job.id,
        priority: delayed_job.priority,
        attempts: delayed_job.attempts,
        queue: delayed_job.queue,
        last_error: delayed_job.last_error,
        failed_at: l_date(delayed_job.failed_at),
        run_at: l_date(delayed_job.run_at),
        created_at: l_date(delayed_job.created_at)
      }
    end

    class << self
      def all
        reports_for(Delayed::Job.all)
      end

      def failed
        reports_for(Delayed::Job.where('delayed_jobs.failed_at IS NOT NULL'))
      end

      def active
        reports_for(Delayed::Job.where('delayed_jobs.locked_by IS NOT NULL'))
      end

      def queued
        reports_for(Delayed::Job.where('delayed_jobs.failed_at IS NULL AND delayed_jobs.locked_by IS NULL'))
      end
      
      def dj_counts
        {
          failed: 0,
          active: 1,
          queued: 2
        }
      end

      def reports_for jobs
        jobs.collect { |job| DjReport.new(job) }
      end
    end

    private

    def l_date date
      date.present? ? I18n.l(date) : ""
    end
  end
end