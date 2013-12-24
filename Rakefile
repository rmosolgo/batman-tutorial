require 'yaml'

def safe_underscore(string)
  string.gsub(/[^a-zA-Z0-9]/, '_').downcase.gsub(/_+/, '_').gsub(/_$/, '')
end

CONFIG = YAML.load_file("_config.yml")
DATA_DIR = '_data/'
TOC = "#{DATA_DIR}table_of_contents.yml"
TOC_INDEX = CONFIG["table_of_contents_index"]

CHAPTERS = FileList[TOC_INDEX.map{|entry| "chapters/#{entry["filename"] || safe_underscore(entry["title"])}.md"}]
CHAPTERS.each do |src|
  if File.exist?(src)
    file TOC => src
  end
end

file TOC do
  #
  # outputs:
  #  - title: Chapter Name
  #    filename: chapter_name
  #    sections:
  #      - title: "What a great section"
  #      - title: "Another great section!"
  #
  HEADING_MATCHER = /^###\s+/
  table_of_contents = []
  CHAPTERS.each_with_index do |file, idx|
    entry = {}
    entry["sections"] = []

    if File.exist?(file)
      entry["filename"] = file.sub(/chapters\/?/, '').sub(/\.md/, '')
      front_matter = YAML.load_file(file)
      entry["title"] = front_matter["title"]
      open(file, 'r+') do |f|
        new_content = ""
        f.each_line do |line|
          if line =~ HEADING_MATCHER
            line.sub!(/\n/, '')
            title = line.sub(HEADING_MATCHER, '')
            anchor = safe_underscore(title)
            named_tag = %{<a name="#{anchor}"></a>}
            line << "#{named_tag}\n"
            entry["sections"] << {"title" => title, "anchor" => anchor}
          end
          new_content << line
        end
        f.rewind
        puts new_content
        f.write(new_content)
      end
    else
      entry["title"] = TOC_INDEX[idx]["title"]
      entry["filename"] = safe_underscore(entry["title"])
    end
    # puts YAML.dump(entry)
    table_of_contents << entry
  end
  open(TOC, "wb+"){ |toc| toc.write(YAML.dump(table_of_contents))}
end

desc "build #{TOC} from _config.yml 'table_of_contents_index'"
task :toc => TOC

