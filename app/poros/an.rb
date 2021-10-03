# load Rails.root.join('app/poros/an.rb')

class An

  module Model

    def self.collect_all_models     
      models  = ::ApplicationRecord.descendants.select { |model| !model.abstract_class? }
      collect = models.map do |model|
       
        path, line_no = ApplicationRecord.const_source_location(model.to_s)
        table_name    = model.table_name
        
        { model => { path: path, table_name: table_name } }

      end.reduce(&:merge)
    end

    Map = collect_all_models

  end
  
  Matcher       = /^=begin\n\n== Schema information.*^?(?=class)/m
  ColumnPadding = 5

  class << self

    def annotate_all
      An::Model::Map.each do |model, atts|
        annotate_model(model: model, **atts.slice(:path, :table_name) )
      end
    end

    private

    def annotate_model(model:, path:, table_name:)
      @model      = model
      @path       = path
      @table_name = table_name
      @columns    = columns
      @contents   = all_text

      File.open(path, "w+") { _1 << @contents }
    end

    def columns
      columns = ApplicationRecord.connection.columns(@table_name)
      sort_columns(columns)
    end

    def sort_columns(columns)
      columns.sort_by { _1.name }
    end

    def schema_header
      name_header    = "column_name".ljust(name_column_width)
      type_header    = "column_type".ljust(type_column_width)
      default_header = "column_default".ljust(default_column_width)
      returns        = "\n\n"
      name_header + type_header + default_header + returns
    end

    def name_column_width  
      [*@columns.map { _1.name.length }, "column_name".length].compact.max + ColumnPadding
    end

    def type_column_width
      [*@columns.map { _1.type.to_s.length }, "column_type".length].compact.max + ColumnPadding      
    end

    def default_column_width
      [*@columns.map { _1.default&.length }, "column_default".length].compact.max + ColumnPadding
    end

    def column_name
      (@column.name || "-").ljust(name_column_width)
    end

    def column_type
      (@column.type.to_s || "-").ljust(type_column_width)
    end

    def column_default
      (@column.default || "-").ljust(default_column_width)
    end

    def column_information(column)
      @column = column
      column_name + column_type + column_default
    end

    def schema_body
      @columns.map { column_information(_1) }.join("\n")
    end

    def exisiting_file_contents
      contents = File.read(@path)
      previous_annotate_stripped = contents.gsub(Matcher, '')
    end

    def all_text
      title + schema_header + schema_body + footer + exisiting_file_contents
    end

    def title
      <<~EOL
        =begin

        == Schema information for table '#{@table_name}'

      EOL
    end

    def footer
    <<~EOL


      =end

      EOL
    end

  end

end
