module DjMon
  class Engine < Rails::Engine
    isolate_namespace DjMon
    config.asset_path = "/dj_mon%s" # note %s at the end
  end
end
