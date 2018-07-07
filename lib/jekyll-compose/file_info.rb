# frozen_string_literal: true

class Jekyll::Compose::FileInfo
  attr_reader :params
  def initialize(params)
    @params = params
  end

  def path
    sub = params.config.dig("jekyll_compose", "defaults", params.layout, "subdirectory")
    if sub
      "#{sub}/"
    else
      ""
    end
  end

  def file_name
    name = Jekyll::Utils.slugify params.title
    "#{name}.#{params.type}"
  end

  def content(custom_front_matter = {})
    meta = {
      "layout" => params.layout,
      "title"  => params.title,
    }.merge(custom_front_matter)

    defs = params.config.dig("jekyll_compose", "defaults")
    front_matter = YAML.dump(meta)
    raw_content = ""
    if defs
      def_layout = defs.dig(meta["layout"], "front_matter")
      if def_layout
        a, b = def_layout.split(/^---\s*$/, 2)
        front_matter += a
        raw_content += b if b
      end
      def_all = defs.dig("all", "front_matter")
      if def_all
        a, b = def_all.split(/^---\s*$/, 2)
        front_matter += a
        raw_content += b if b
      end
    end

    front_matter + "---\n" + raw_content
  end
end
