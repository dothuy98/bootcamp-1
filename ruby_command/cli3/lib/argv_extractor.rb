module ArgvExtractor

  class << self
    def select_keywords(argvs)
      argvs.reject.with_index do |argv, index|
        /^-/.match(argv) || (/^-/.match(argvs[index - 1]) && index != 0)
      end
    end

    def select_options(argvs)
      return {} unless argvs.any? { |argv| /^-/.match(argv) }
      
      options = {}
      argvs.each_with_index do |argv, index|
        next unless /^-/.match(argv)
        
        options['asc'] = true if argv == '-a' || argv == '--asc'
        options['desc'] = true if argv == '-d' || argv == '--desc'
        options['help'] = true if argv == '-h' || argv == '--help'
        options['cheap'] = true if argv == '-c' || argv == '--cheap'
        options['expensive'] = true if argv == '-e' || argv == '--expensive'
        options['max_count'] = argvs[index + 1].to_i if argv == '-n' || argv == '--max_count'
        options['not'] = argvs[index + 1] if argv == '-!' || argv == '--not'
      end
      options
    end
  end

end