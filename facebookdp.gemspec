require 'rubygems'
require 'rake'

Gem::Specification.new do |s|
  s.name      =   "facebookdp"
  s.version   =   "0.1.0"
  s.platform  =   Gem::Platform::RUBY
  s.summary   =   "Exposes Facebook OAuth2 Graph Rest API and provides ability to authenticate users against Facebook"
  s.require_path  =  "lib"
  s.files     =   FileList["[A-Z]*", "{lib,test}/**/*"]
  s.author    =   "Dave Paroulek"
  s.email     =   "dave @nospam@ daveparoulek.com"
  s.has_rdoc  =   true
  s.description = "Consumes the Facebook OAuth2 Graph Rest API"
  s.homepage = "http://upgradingdave.com"
  # s.extra_rdoc_files  =   ["README"]
end
