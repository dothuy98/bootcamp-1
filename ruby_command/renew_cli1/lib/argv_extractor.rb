module ArgvExtractor

  class << self
    def select_file_names(argvs)
      argvs.reject { |argv| /^-/.match(argv) }
    end

    def find_option(argvs)
      return nil unless argvs.any? { |argv| /^-/.match(argv) }
      return argvs.find { |argv| /^--/.match(argv) }.sub(/^--/, '') if argvs.any? { |argv| /^--/.match(argv) }
      
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