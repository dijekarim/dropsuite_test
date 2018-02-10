require 'rack'
require 'hanami/router'
require 'cells'
require 'cells-erb'

# Load Controllers
Dir[File.join(File.dirname(__FILE__), 'app/controllers', '**', '*.rb')].sort.each {|file| require file }
# Load cells
Dir[File.join(File.dirname(__FILE__), 'app/cells', '**', '*.rb')].sort.each {|file| require file }

app = Hanami::Router.new do
  get '/', to: Post::Show
  get '/data', to: Post::Show
  get '/data/:data', to: Post::Show
end

Rack::Server.start app: app, Port: 2300