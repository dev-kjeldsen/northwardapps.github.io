Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require "html-proofer"

SITE_DIR = "_site"

desc "Build the site, validate HTML/links, and lint post front matter"
task test: %w[build htmlproofer lint]
task default: :test

desc "Build the Jekyll site (includes future-dated posts)"
task :build do
  require "jekyll"
  Jekyll::Commands::Build.process(source: ".", destination: SITE_DIR, future: true)
end

desc "Validate HTML structure and internal links"
task :htmlproofer do
  options = {
    disable_external: true,
    ignore_urls: [/^mailto:/],
    ignore_files: [/feed\.xml/]
  }
  HTMLProofer.check_directory(SITE_DIR, options).run
end

desc "Lint post front matter for required fields and SEO constraints"
task :lint do
  load "_scripts/lint_posts.rb"
end
