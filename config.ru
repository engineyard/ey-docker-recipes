rack_app = lambda {|env| [200, {}, ["My Rack App"]] }
run rack_app
