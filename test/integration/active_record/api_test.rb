require_relative '../../test_helper'

Delayed::Worker.max_attempts = 1
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 20
Delayed::Worker.max_run_time = 30
Delayed::Worker.read_ahead = 5
Delayed::Worker.delay_jobs = true

Dummy::Application.routes.draw do
  mount DjMon::Engine=> 'dj_mon'
end

class ApiTest < ActionDispatch::IntegrationTest

  setup { Delayed::Job.destroy_all }

  context "authorization" do
    %w(all failed active queued dj_counts settings).each do |protected_get|
      should "not allow unauthorized GET to /dj_reports/#{protected_get}" do
        unauthorized_get "/dj_mon/dj_reports/#{protected_get}", format: 'json'

        assert_equal 401, status
      end
    end

    should "not allow unauthorized POST access to /dj_reports/retry" do
      unauthorized_post "/dj_mon/dj_reports/100/retry/", format: 'json'
      assert_equal 401, status
    end

    should "not allow unauthorized DELETE access to /dj_reports/delete" do
      unauthorized_delete "/dj_mon/dj_reports/100/", format: 'json'
      assert_equal 401, status
    end
  end

  context "/dj_counts" do
    setup do
      5.times { Delayed::Job.enqueue(FailingTestJob.new) }
      Delayed::Worker.new.work_off
      3.times { Delayed::Job.enqueue(TestJob.new) }
    end

    should "have counts for all, active, queued, failed jobs" do
      authorized_get '/dj_mon/dj_reports/dj_counts', format: 'json'

      assert_equal 200, status
      assert_equal({ all: 8, active: 0, failed: 5, queued: 3 }, json_response.symbolize_keys)
    end
  end

  context "/settings" do
    should "return delayed job settings" do
      authorized_get '/dj_mon/dj_reports/settings', format: 'json'

      assert_equal 200, status

      assert_equal 1, json_response['max_attempts']
      assert_equal 20, json_response['sleep_delay']
      assert_equal 30, json_response['max_run_time']
      assert_equal 5, json_response['read_ahead']

      assert json_response['delay_jobs']
      assert !json_response['destroy_failed_jobs']
      assert_match /\d+\.\d+.\d+/, json_response['delayed_job_version']
      assert_match /\d+\.\d+.\d+/, json_response['dj_mon_version']
    end
  end

  context "/failed" do
    setup do
      2.times { Delayed::Job.enqueue(FailingTestJob.new, queue: "queue_mailer_1", priority: 3) }
      Delayed::Worker.new.work_off
    end

    should "return details of failed jobs" do
      authorized_get '/dj_mon/dj_reports/failed', format: 'json'

      assert_equal 2, json_response.size
      assert_job({failed: true, priority: 3, attempts: 1, queue: 'queue_mailer_1'}, json_response.first)
    end
  end

  context "/queued" do
    setup do
      3.times { Delayed::Job.enqueue(TestJob.new, priority: 2, queue: 'queue_mailer_2') }
    end

    should "return details of queued jobs" do
      authorized_get '/dj_mon/dj_reports/queued', format: 'json'

      assert_equal 3, json_response.size
      assert_job({failed: false, priority: 2, attempts: 0, queue: 'queue_mailer_2'}, json_response.first)
    end
  end

  context "/active" do
    setup do
      2.times do
        job = Delayed::Job.enqueue(TestJob.new, priority: 2, queue: 'queue_mailer_3')
        job.lock_exclusively!(30, 'some worker')
      end
    end

    should "return details of active jobs" do
      authorized_get '/dj_mon/dj_reports/active', format: 'json'

      assert_equal 2, json_response.size
      assert_job({failed: false, priority: 2, attempts: 0, queue: 'queue_mailer_3'}, json_response.first)
    end
  end

  context "/all" do
    setup do
      Delayed::Job.enqueue(FailingTestJob.new, priority: 1, queue: 'queue_mailer_1')
      Delayed::Worker.new.work_off
      Delayed::Job.enqueue(TestJob.new, priority: 2, queue: 'queue_mailer_2')
      Delayed::Job.enqueue(TestJob.new, priority: 3, queue: 'queue_mailer_3').lock_exclusively!(30, 'some worker')
    end

    should "return details of queued, failed and active jobs" do
      authorized_get '/dj_mon/dj_reports/all', format: 'json'

      assert_equal 3, json_response.size
      assert_job({failed: true,  priority: 1, attempts: 1, queue: 'queue_mailer_1'}, json_response[0])
      assert_job({failed: false, priority: 2, attempts: 0, queue: 'queue_mailer_2'}, json_response[1])
      assert_job({failed: false, priority: 3, attempts: 0, queue: 'queue_mailer_3'}, json_response[2])
    end
  end

  private

  def assert_job(expected, actual)
    assert_equal expected[:failed], actual['failed']
    assert_match /\d+/, actual['id'].to_s
    assert_equal expected[:priority], actual['priority']
    assert_equal expected[:attempts], actual['attempts']
    assert_equal expected[:queue], actual['queue']
    if expected[:failed]
      assert_equal "--- !ruby/object:FailingTestJob {}\n", actual['payload']
      assert_include actual['last_error'], "this one fails"
      assert_include actual['last_error_summary'], "this one fails"
      assert_not_nil DateTime.strptime(actual['failed_at'], DjMon::DjReport::TIME_FORMAT)
    else
      assert_equal "--- !ruby/object:TestJob {}\n", actual['payload']
      assert actual['failed_at'].empty?
      assert_nil actual['last_error']
      assert actual['last_error_summary'].empty?
    end
    assert_not_nil DateTime.strptime(actual['created_at'], DjMon::DjReport::TIME_FORMAT)
    assert_not_nil DateTime.strptime(actual['run_at'], DjMon::DjReport::TIME_FORMAT)
  end

  def json_response
    ActiveSupport::JSON.decode(response.body)
  end

  def authorized_get(url, params)
    get url, params, { 'HTTP_AUTHORIZATION'=> ActionController::HttpAuthentication::Basic.encode_credentials('dj_mon', 'password') }
  end

  def unauthorized_get(url, params)
    get url, params, { 'HTTP_AUTHORIZATION'=> ActionController::HttpAuthentication::Basic.encode_credentials('dj_mon', 'gibber') }
  end

  def unauthorized_post(url, params)
    post url, params, { 'HTTP_AUTHORIZATION'=> ActionController::HttpAuthentication::Basic.encode_credentials('dj_mon', 'gibber') }
  end

  def unauthorized_delete(url, params)
    delete url, params, { 'HTTP_AUTHORIZATION'=> ActionController::HttpAuthentication::Basic.encode_credentials('dj_mon', 'gibber') }
  end

end
