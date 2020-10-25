require './lib/trash_command'

COMPRESS = %w[zip ]
OPTIONS = %w[--restore -r --view -v --compress -c --delete -d]

ARGV.each do |value|
  next unless /^-/.match(value)
  raise "trash unknown predicate `#{value}'" unless OPTIONS.include?(value)
end

if ARGV.include?("-h") || ARGV.include?("--help")
  file = TrashCommand.new
  file.view_help
  exit
end

ARGV.each_with_index do |value|
  next unless /^-/.match(value)
  case value
  #when "-h","--help"
  when "--restore","-r"
    if ARGV[index + 1].nil? && /^[^-]/.match(ARGV[index + 1])
      file_name = ARGV[index + 1]
    else
      file_name = ARGV[index + 1]
    end
    file = TrashCommand.new
    file.restore(file_name)
    exit
  when
    
end

file = TrashCommand.new
file.move_to_trash(ARGV[0])
