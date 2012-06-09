# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "dj_mon"
  s.summary = "A Frontend for Delayed Job."
  s.description = "A Rails engine based frontend for Delayed Job"
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md"]
  s.authors     = ["Akshay Rawat"]
  s.email       = ["projects@akshay.cc"]
  s.homepage    = "http://portfolio.akshay.cc/dj_mon/"

  s.add_dependency "rails", "~> 3.1"
  s.add_dependency "haml", "~> 3.1"

  s.version = "0.0.5"
end