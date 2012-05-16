# RackWiki

Write markdown pages, including nested directories and a common .erb layout. Have Rack serve them for you on any Rack-enabled server.

Extracted from the Bootic wiki at [wiki.bootic.net](http://wiki.bootic.net)

NOTE: WiP, not tested.

## Installation

    # config.ru
    require 'rack_wiki'
    RackWiki::App.set :root, Dir.pwd
    run RackWiki::App

## Usage

A site looks like this:

    pages/
      layout.erb
      01_index.mkd
      index/
        01_page1.mkd
        02_page2.mkd
        
RackWiki builds a nested, ordered pages menu for you. You can use it with the `menu` helper:

```html
<ul class="nested_menu">
  <% menu.each do |page| %>
    <%= build_menu page %>
  <% end %>
</ul>
````

Look in the ./examples directory for more.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
