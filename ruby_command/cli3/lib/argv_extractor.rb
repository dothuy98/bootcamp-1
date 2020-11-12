module ArgvExtractor

  class << self
    def select_keywords(argvs)
      argvs.select { |argv| !/^-/.match(argv) }
    end

    def find_option(argvs)
      return nil unless argvs.any? { |argv| /^-/.match(argv) }
      return argvs.find { |argv| /^--/.match(argv) }.sub(/^--/, '') if argvs.any? { |argv| /^--/.match(argv) }
      
      options = {
        '-a' => 'asc',
        '-d' => 'desc',
        '-h' => 'help'
      }
      options[argvs.find { |argv| /^-/.match(argv) }]
    end
  end

end