module RackWiki
  
  module Helpers
    def cache_long(seconds = 3600)
      response['Cache-Control'] = "public, max-age=#{seconds.to_i}"
    end

    def mkd(page)
      @content = render_markup(page.body)
      pjax? ? @content : erb(:layout)
    end

    def render_markup(markup)
      erb_content = ERB.new(markup).result(binding)
      RDiscount.new(erb_content).to_html
    end

    def coderay(body)
      body.gsub!(/<pre>:::(\w+)?\s(.+?)?<\/pre>/im) do |match|
        "<pre class='CodeRay'>#{::CodeRay.encoder(:html).encode($2, $1)}</pre>"
      end
    end

    def render_404
      @content = RDiscount.new(File.read(File.join(settings.views, '404.mkd'))).to_html
      halt 404, erb(:layout)
    end

    def partial(page, options={})
      erb :"_#{page}", options.merge!(:layout => false)
    end

    def menu
      @menu ||= Page.root
    end

    def pjax?
      !!request.env['HTTP_X_PJAX']
    end

    def load_page(url, json = false)
      if @page = Page.find('/'+url)
        mkd @page
      else
        render_404
      end
    end

    def recursive_xml(xml, page, level = 1.0)
      xml.url do
          xml.loc url(page.url)
          xml.changefreq "weekly"
          xml.priority(page.sitemap_priority || level)
      end

      page.each do |child|
        recursive_xml xml, child, level/2
      end if page.size > 0
    end

    def build_menu(page, depth = 1)
      klass = 'current' if @page && page.url == @page.url
      str = %(<li class="page depth_#{depth}">)
      str << %(<a href="#{page.url}" class="#{klass}" title="#{page.description}">#{page.title}</a>)
      if page.size > 0
        page.each do |child|
          str << %(<ul>)
          str << build_menu(child, depth + 1)
          str << %(</ul>)
        end
      end
      str << %(</li>)
    end

    def current_url
      return '' unless @page
      "http://#{request.env['HTTP_HOST']}#{@page.url}"
    end

    def development?
      ENV['RACK_ENV'] == 'development'
    end

    def img(path, size = nil)
      ::IMAGES.fetch(path.sub(/^\//, ''))
    end

  end
  
end