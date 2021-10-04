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
      @contents   = generate_schema_information

      File.open(path, "w+") { _1 << @contents }
    end

    def generate_schema_information
      title + informational_header + table_information + footer + exisiting_file_contents
    end

    def columns
      columns = ApplicationRecord.connection.columns(@table_name)
      sort_columns(columns)
    end

    def sort_columns(columns)
      columns.sort_by { _1.name }
    end

    def table_information
      @columns.map { column_information(_1) }.join("\n")
    end

    def exisiting_file_contents
      contents = File.read(@path)
      previous_annotate_stripped = contents.gsub(Matcher, '')
    end

    def informational_header
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

    def name_column_value
      (@column.name || "-").ljust(name_column_width)
    end

    def type_column_value
      (@column.type.to_s || "-").ljust(type_column_width)
    end

    def default_column_value
      (@column.default || "-").ljust(default_column_width)
    end

    def column_information(column)
      @column = column
      name_column_value + type_column_value + default_column_value
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

  class << self
    # drafts for routes

    def routes_path
      @routes_path ||= Rails.root.join("config/routes")
    end

    def routes
      @routes ||= `rails routes`.chomp("\n").split(/\n/, -1)
    end

    # test_routes = []
    # Rails.application.routes.routes.each do |route|
    #   route = route.path.spec.to_s
    #   test_routes << route if route.starts_with?('/admin')
    # end
  end

end
