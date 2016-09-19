require_relative "polytreenode"
require 'set'
require "byebug"

class WordChain
  attr_reader :start_word, :end_word

  def initialize(dictionary_file_name)
    @dictionary = File.readlines(dictionary_file_name).map(&:chomp)
    @dictionary = Set.new(@dictionary)
  end

  def find_path(start_word,end_word)
    @start_word = start_word
    @end_word = end_word
    @visited_words = [@start_word]
    self.build_chain_tree
    end_node = @root_node.bfs(end_word)
    self.trace_path_back(end_node).reverse.map(&:value)
  end

  def valid_changes(word)
    result = []
    debugger if word.nil?
    word.each_char.with_index do |_,idx|
      ("a".."z").each do |letter|
        new_word = word.dup
        new_word[idx] = letter
        result << new_word if @dictionary.include?(new_word) && new_word != word
      end
    end
    result
  end

  def new_words(word)
    possible_words = self.valid_changes(word)
    possible_words.delete_if do |ele|
      @visited_words.include?(ele)
    end
    @visited_words += possible_words
    possible_words
  end

  def build_chain_tree
    @root_node = PolyTreeNode.new(@start_word)
    queue = [@root_node]
    until queue.empty?
      root = queue.shift
      children_words = self.new_words(root.value)
      children_words.each do |word|
        child = PolyTreeNode.new(word)
        root.add_child(child)
        queue.push(child)
      end
    end
  end

  def trace_path_back(end_node)
    result = []
    current_node = end_node
    until current_node.nil?
      result << current_node
      current_node = current_node.parent
    end
    result
  end
end

if __FILE__ == $PROGRAM_NAME
  wd = WordChain.new("dictionary.txt")
  p wd.find_path("duck","ruby")
end
