# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rack_wiki/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ismael Celis"]
  gem.email         = ["ismaelct@gmail.com"]
  gem.description   = %q{Rack-based markdown wiki}
  gem.summary       = %q{Rack-based markdown wiki}
  gem.homepage      = ""
  
  gem.add_dependency 'sinatra'
  gem.add_dependency 'rdiscount'
  gem.add_dependency 'dragonfly', '0.8.2'
  gem.add_dependency 'multi_json'
  gem.add_dependency 'builder'
  gem.add_development_dependency 'shotgun'
  
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "rack_wiki"
  gem.require_paths = ["lib"]
  gem.version       = RackWiki::VERSION
end
