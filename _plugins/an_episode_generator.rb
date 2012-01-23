module Jekyll

  class Episode < Page
    def initialize(site, base, episode, type=nil)
      @site = site
      @base = base
      @dir = episode
      layout = type || "index"
      if type
        @name = File.join(type, "index.html")
      else
        @name = "index.html"
      end

      self.process(@name)
      self.read_yaml(File.join(base, episode), '_episode.html')
      self.data['layout'] = "episode_#{layout}"
      self.data['is_episode_landing'] = !type
      self.data['episode'] = episode

    end
  end

  class EpisodeGenerator < Generator
    safe true
    
    def generate(site)
      site.config['episodes'].each do |episode|

        write_episode(site, episode)
        write_episode(site, episode, 'photos')
        write_episode(site, episode, 'recipe')

      end
    end
  
    def write_episode(site, episode, type=nil)
      page = Episode.new(site, site.source, episode, type)

      page.render(site.layouts, site.site_payload)
      page.write(site.dest)
      site.pages << page
    end
  end

end