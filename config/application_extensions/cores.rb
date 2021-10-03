class Folder::Application < Rails::Application

  module Cores

    Namespace = %i( billing planning )
    TopLevel  = %i( firm revenue )
    All       = Namespace | TopLevel
    Root      = Rails.root.join('app/cores')
    
  end

  module Zeitwerk

    def self.collect_directories(const)
      const.constants
           .map { |container| const_get("#{const}::#{container}") }.flatten
           .map { |path| Rails.application.root.join(path) }
    end

    module Collapse

      Core          = [ "app/cores/{#{Cores::All.join(',')}}/{classes,jobs,decorators,sql,services}",
                        "app/cores/{#{Cores::All.join(',')}}/classes/*",
                        "app/cores/{#{Cores::All.join(',')}}/classes/**/extensions" ]
      TopLevelCore  = [ "app/cores/{#{Cores::TopLevel.join(',')}}" ]
      Controller    = [ "app/controllers/*" ]
      Railtie       = [ "app/railties/*" ]

      Rails.autoloaders.main.collapse(Zeitwerk.collect_directories(Collapse))

    end

    module Ignore

      Core = [ "app/cores/{#{Cores::All.join(',')}}/{specs}" ]
      
      Rails.autoloaders.main.collapse(Zeitwerk.collect_directories(Ignore))

    end

  end

end