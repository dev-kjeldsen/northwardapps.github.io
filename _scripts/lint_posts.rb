#!/usr/bin/env ruby
# Validates YAML front matter on every post in _posts/.
require "yaml"
require "date"

REQUIRED_FIELDS = %w[layout title date author description].freeze
MAX_DESCRIPTION_LENGTH = 160
POSTS_DIR = File.expand_path("../_posts", __dir__)

errors = []
post_files = Dir.glob(File.join(POSTS_DIR, "*.md")).sort

post_files.each do |path|
  filename = File.basename(path)
  content = File.read(path, encoding: "utf-8")

  unless content.start_with?("---")
    errors << "#{filename}: missing front matter"
    next
  end

  fm_raw = content.match(/\A---\s*\n(.*?)\n---/m)&.captures&.first
  unless fm_raw
    errors << "#{filename}: malformed front matter (no closing ---)"
    next
  end

  fm = begin
    YAML.safe_load(fm_raw, permitted_classes: [Date, Time])
  rescue Psych::SyntaxError => e
    errors << "#{filename}: YAML parse error — #{e.message}"
    next
  end

  REQUIRED_FIELDS.each do |field|
    errors << "#{filename}: missing required field '#{field}'" if fm[field].nil? || fm[field].to_s.strip.empty?
  end

  desc = fm["description"]
  if desc && desc.length > MAX_DESCRIPTION_LENGTH
    errors << "#{filename}: description is #{desc.length} chars (max #{MAX_DESCRIPTION_LENGTH} for SEO)"
  end

  filename_date = filename.match(/\A(\d{4}-\d{2}-\d{2})-/)&.captures&.first
  if filename_date && fm["date"]
    post_date = fm["date"].to_s.split(" ").first
    errors << "#{filename}: date '#{post_date}' does not match filename date '#{filename_date}'" if post_date != filename_date
  end

  if fm["layout"] && fm["layout"] != "post"
    errors << "#{filename}: layout should be 'post', got '#{fm["layout"]}'"
  end
end

if errors.empty?
  puts "lint_posts: #{post_files.length} post(s) OK"
else
  errors.each { |e| warn "ERROR: #{e}" }
  exit 1
end
