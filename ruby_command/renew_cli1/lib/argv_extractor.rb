module ArgvExtractor

  class << self
    def select_arguments(argvs)
      argvs.reject { |argv| /^-/.match(argv) }
    end

    def find_option(argvs)
      return nil unless argvs.any? { |argv| /^-/.match(argv) }
      
      options = {
        '-h' => 'help',
        '-r' => 'restore',
        '-d' => 'delete',
        '-v' => 'view'
      }
      options[argvs.find { |argv| /^-/.match(argv) }]
    end
  end

end