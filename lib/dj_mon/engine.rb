module DjMon
  class Engine < Rails::Engine

    isolate_namespace DjMon

    if Rails.version > "3.1"
      config.after_initialize "DJMon precompile hook" do
        Rails.application.config.assets.precompile += ['dj_mon.js', 'dj_mon.css']
      end
    end

  end
end
