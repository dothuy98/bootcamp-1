require './lib/trash_command'
require 'fileutils'
require 'minitest/autorun'

class TrashTest < Minitest::Test
  PATH = "#{Dir.home}/.trash"
  def test_mkdir
    FileUtils.rm_r(PATH) if Dir.exist?(PATH)
    file = TrashCommand.new
    assert Dir.exist?(PATH)
  end

  def test_help
    file = TrashCommand.new
    help_message = file.view_help
    # puts help_message
    assert !help_message.nil?
  end

  def test_move
    FileUtils.rm_r(PATH) if Dir.exist?(PATH)
    Dir.mkdir("test_move")
    file = TrashCommand.new
    file.move_to_trash("test_move")
    assert !Dir.exist?("test_move")
    assert Dir.exist?("#{PATH}/test_move")

    assert File.exist?("#{PATH}/index_file.txt")
    text = ""
    File.open("#{PATH}/index_file.txt") { |file| text = file.read }
    #  puts text
    assert text.include?("test_move")
  end

  def test_restore
    FileUtils.rm_r(PATH) if Dir.exist?(PATH)
    Dir.mkdir("test_move2")
    file = TrashCommand.new
    file.move_to_trash("test_move2")
    file.restore('test_move2')
    assert Dir.exist?('test_move2')
    Dir.rmdir('test_move2')
  end
end

