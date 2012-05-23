# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "dj_mon"
  s.summary = "A Frontend for Delayed Job."
  s.description = "A Rails engine based frontend for Delayed Job"
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.authors     = ["Akshay Rawat"]
  s.email       = ["projects@akshay.cc"]
  s.homepage    = "http://github.com/akshayrawat/dj_mon"

  s.add_dependency "rails", "~> 3.1"
  s.add_dependency "haml", "~> 3.1"

  s.add_dependency "jquery-rails", "~> 2.0"
  s.add_dependency "sass-rails", "~> 3.1"
  s.add_dependency "bootstrap-sass", "~> 2.0.2"

  s.version = "0.0.1"
end