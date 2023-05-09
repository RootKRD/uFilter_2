require 'optparse'
require 'open-uri'
require 'io/console'

def clear_console
  if Gem.win_platform?
    system('cls')
  else
    system('clear')
  end
end
bn = <<~BANNER
          ______   _   _   _
         |  ____| (_) | | | |                 0.1v
  _   _  | |__     _  | | | |_    ___   _ __
 | | | | |  __|   | | | | | __|  / _ \\ | '__|
 | |_| | | |      | | | | | |_  |  __/  | |
  \\__,_| |_|      |_| |_| \\__|   \\___|  |_|

 URL to fetch and Filter 'uFilter'
 T.me: RootKrd


BANNER

puts bn
def get_filtered_urls(url, extensions)
  archive_url = "https://web.archive.org/cdx/search/cdx?url=#{url}/*&output=text&fl=original&collapse=urlkey"
  response = URI.open(archive_url).read
  urls = response.split

  filtered_urls = urls.select do |url|
    extensions.any? { |ext| url.end_with?(".#{ext}") }
  end

  filtered_urls
end

def print_usage(opts)
  puts opts
  puts "\nUsage: ruby uFilter.rb [OPTIONS] URL\n\n"
  puts "Examples:"
  puts "  ruby uFilter.rb -j -p example.com          # Fetch and filter JavaScript and Python files"
  puts "  ruby uFilter.rb -h                          # Display this message"
  puts "  ruby uFilter.rb example.com                # Fetch all URLs from example.com"
end

extensions = []

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby uFilter.rb [OPTIONS] URL"

  opts.on("-js", "--javascript", "Filter JavaScript files") do extensions << "js"
  end

  opts.on("-pt", "--python", "Filter Python files") do extensions << "py"
  end

  opts.on("-json", "--json", "Filter JSON files") do extensions << "json"
  end

  opts.on("-svg", "--svg", "Filter SVG files") do extensions << "svg"
  end

  opts.on("-php", "--php", "Filter PHP files") do extensions << "php"
  end

  opts.on("-html", "--html", "Filter HTML files") do extensions << "html"
  end

  opts.on("-txt", "--txt", "Filter TXT files") do extensions << "txt"
  end

  opts.on("-asp", "--asp", "Filter ASP files") do extensions << "asp"
  end

  opts.on("-aspx", "--aspx", "Filter ASPX files") do extensions << "aspx"
  end

  opts.on("-db", "--database", "Filter DBS files") do extensions << "db"
  end

  opts.on("-sql", "--sql", "Filter SQL files") do extensions << "sql"
  end

  opts.on("-h", "--help", "Prints this help") do print_usage(opts)
    exit
  end
end

begin
  opt_parser.parse!
  url = ARGV.pop

  if url.nil?
    print_usage(opt_parser)
    exit
  end

  filtered_urls = get_filtered_urls(url, extensions)

  if filtered_urls.empty?
    puts "No URLs found with the specified filters."
  else
    puts filtered_urls
  end

rescue OptionParser::InvalidOption => e
  puts "Invalid option: #{e}"
  print_usage(opt_parser)
end
