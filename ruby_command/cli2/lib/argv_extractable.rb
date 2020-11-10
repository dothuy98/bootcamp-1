module ArgvExtractable
  
  class << self
    def select_arguments(argvs)
      argvs.select { |argv| !/^-/.match(argv) }
    end
    
    def find_option(argvs)
      return 'synonyms' unless argvs.any? { |argv| /^-/.match(argv) }
      return argvs.find { |argv| /^--/.match(argv) }.sub(/^--/, '') if argvs.any? { |argv| /^--/.match(argv) }
      options = {
        '-s' => 'synonyms',
        '-a' => 'antonyms',
        '-d' => 'definitions',
        '-e' => 'examples',
        '-h' => 'help'
      }
      options[argvs.find { |argv| /^-/.match(argv) }]
    end
  end
  
end
