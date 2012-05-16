$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rack_wiki'
RackWiki::App.set :root, File.expand_path('.')
run RackWiki::App