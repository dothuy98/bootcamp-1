module ArgvExtractor

  class << self
    def select_keywords(argvs)
      argvs.reject.with_index do |argv, index|
        /^-/.match(argv) || (/^-/.match(argvs[index - 1]) && index != 0)
      end
    end

    def select_options(argvs)
      options = {}
      argvs.each_with_index do |argv, index|
        options[:desc] = true if argv == '-d' || argv == '--desc'
        options[:help] = true if argv == '-h' || argv == '--help'
        options[:not] = argvs[index + 1] if argv == '-!' || argv == '--not'
      end
      options
    end
  end

end