module RackWiki
  
  # encoding: UTF-8

  class App < Sinatra::Base

    set :public_folder do
      File.join(settings.root, 'public')
    end
    set :views do
      File.join(settings.root, 'pages')
    end
    
    set :private_views_path, File.join(File.dirname(__FILE__), 'templates')

    disable :protection # allow jsonp
    
    helpers do
      include Helpers
    end
    
    configure do
      ::IMAGES = Dragonfly[:images].configure_with(:imagemagick).configure do |c|
        c.url_path_prefix = '/i'
        c.protect_from_dos_attacks = true
        c.secret = ENV['DRAGONFLY_SECRET'] || 'f00barsupers3cr3t'
      end
      IMAGES.datastore.configure do |d|
        d.root_path = settings.public_folder
      end
    end

    before do
      Page.load(File.join(settings.views), ['404.mkd'])
      cache_long
    end

    get '/sitemap.xml' do
      builder :sitemap, :views => settings.private_views_path
    end

    get '/robots.txt' do
      content_type 'text/plain'
      erb :robots, :layout => false, :views => settings.private_views_path
    end

    get '/index.json' do
      content_type 'application/json'
      MultiJson.encode Page.flat_list(url(''))
    end

    # resizable images with Dragonfly
    get '/i/:path' do |path|
      Dragonfly::Job.from_path(path, IMAGES).validate_sha!(params[:s]).to_response(env)
    end

    get '/?' do
      load_page ''
    end

    get '/*.json' do
      if page = Page.find('/'+params[:splat].first)
        content_type 'application/json'
        data = page.serializable_hash(url(''))
        data[:body] = coderay(render_markup(page.body))
        MultiJson.encode data
      else
        render_404
      end
    end

    get '/*' do
      load_page params[:splat].first
    end

  end
  
  
end