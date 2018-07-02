# frozen_string_literal: true

class Jekyll::Compose::FileInfo
  attr_reader :params
  def initialize(params)
    @params = params
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

    defs = params.options["defaults"]
    if defs
      def_all = defs["all"]
      def_layout = defs[meta["layout"]]
      meta = def_layout.merge(meta) if def_layout
      meta = def_all.merge(meta) if def_all
    end

    c = meta.delete("content").to_s
    YAML.dump(meta) + "---\n" + c
  end
end
