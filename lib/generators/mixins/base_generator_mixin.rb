module BaseGeneratorMixin
  extend ActiveSupport::Concern
  included do

    private

    def validate_name_as_core
      unless name =~ /^[a-zA-Z_]{1,}$/
        raise ArgumentError, "invalid core name, it should be of the format 'core_name'"
      end  
    end

    def validate_name_as_core_class
      unless name =~ /^[a-z|_]{1,}\/[a-z|_]{1,}$/
        raise ArgumentError, "the argument should be of the format 'core_name/class_name'"
      end
    end

    def mkdir(directory)
      Dir.mkdir(directory)
      print_mkdir(directory)
    end

    def print_mkdir(directory)
      subdir = directory.to_s.slice /\/app\/[a-zA-Z_\/]{1,}/
      puts "created directory #{subdir}"
    end

  end
end