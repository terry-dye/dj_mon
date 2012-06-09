module DjMon
  class DjReport
    attr_accessor :delayed_job
    
    def initialize delayed_job
      self.delayed_job = delayed_job
    end

    def as_json(options={})
      { 
        id: delayed_job.id,
        payload: delayed_job.payload_object.object.to_yaml,
        priority: delayed_job.priority,
        attempts: delayed_job.attempts,
        queue: delayed_job.queue,
        last_error_summary: delayed_job.last_error.to_s.truncate(30),
        last_error: delayed_job.last_error,
        failed_at: l_date(delayed_job.failed_at),
        run_at: l_date(delayed_job.run_at),
        created_at: l_date(delayed_job.created_at)
      }
    end

    class << self

      def all
        Delayed::Job.all
      end

      def failed
        Delayed::Job.where('delayed_jobs.failed_at IS NOT NULL')
      end

      def active
        Delayed::Job.where('delayed_jobs.locked_by IS NOT NULL')
      end

      def queued
        Delayed::Job.where('delayed_jobs.failed_at IS NULL AND delayed_jobs.locked_by IS NULL')
      end

      def reports_for jobs
        jobs.collect { |job| DjReport.new(job) }
      end

      def all_reports
        reports_for all
      end

      def failed_reports
        reports_for failed
      end

      def active_reports
        reports_for active
      end

      def queued_reports
        reports_for queued
      end

      def dj_counts
        {
          failed: failed.size,
          active: active.size,
          queued: queued.size
        }
      end

    end

    private

    def l_date date
      date.present? ? I18n.l(date) : ""
    end
  end
end