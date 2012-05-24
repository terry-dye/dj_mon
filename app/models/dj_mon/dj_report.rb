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
    
    def l_date date
      date.present? ? I18n.l(date) : ""
    end
  end
end