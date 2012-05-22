module DjMon
  class Engine < Rails::Engine

    isolate_namespace DjMon

    if Rails.version > "3.1"
      initializer "DJMon precompile hook" do |app|
        puts "Adding"
        app.config.assets.precompile += ['dj_mon.js', 'dj_mon.css']
      end
    end

  end
end
