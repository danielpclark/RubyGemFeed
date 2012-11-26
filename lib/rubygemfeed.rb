require 'rubygems'
require 'open-uri'
require 'json'
require 'mightystring'
require 'rubygemfeed/version'

module RubyGemFeed
  MAX_INFO_LENGTH = 76
  
  def self.parse_url(in_url = 'https://rubygems.org/api/v1/activity/latest.json')
    content = open(in_url).read
    rgems = JSON.parse(content)
    self.parse(rgems)
  end

  def self.parse(rgems)
    rgnames = []
    rgems.each do |x|
      rgnames << [x['name'], x['version'], x['authors'], x['info'], x['project_uri']]
    end
    puts (
      rgnames.map { |x|
        x[0] = (
          x[0].gsub(/([-_])/, ' ').split.map { |y|
            y.capitalize
          }
        ).join(' ')
        x[3] = x[3][0..MAX_INFO_LENGTH]
        "\n#{x[0]} #{x[1]} ( by #{x[2]} )\n  #{x[3]}\n  #{x[4]}\n"
      }
    )
  end
  
  def self.new50
    self.parse_url
  end
  
  def self.updated50
    self.parse_url('https://rubygems.org/api/v1/activity/just_updated.json')
  end
  
  def self.querygem(name)
    begin
      rgem = JSON.parse(open("https://rubygems.org/api/v1/gems/#{name.strip_byac((('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['-','_']).flatten.join(''))}.json").read)
      self.parse([rgem])
    rescue
      puts "\n!!! GEM #{name} NOT FOUND !!!\n" 
    end
  end
end
