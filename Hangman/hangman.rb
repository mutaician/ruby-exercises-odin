require 'json'
require 'fileutils'

class Hangman
  attr_reader :secret_word, :guessed_letters, :remaining_guesses
  GAME_SAVES_DIR = FileUtils.mkdir_p('saved_games')

  def initialize(words_file_path)
    @words = read_words_from_file(words_file_path)
    @secret_word = select_random_word()
    @guessed_letters = []
    @remaining_guesses = rand(5..12)
  end

  def serialize_game_state
    {
      secret_word: @secret_word,
      guessed_letters: @guessed_letters,
      remaining_guesses: @remaining_guesses
  }.to_json
  end

  def load_game(file_path)
    file_path = File.join(GAME_SAVES_DIR, file_path)
    begin
      saved_data = File.read(file_path)
      game_state = JSON.parse(saved_data)
      @secret_word = game_state['secret_word']
      @guessed_letters = game_state['guessed_letters']
      @remaining_guesses = game_state['remaining_guesses']
      puts "Game loaded from #{file_path}"
    rescue Errno::ENOENT
      puts "No saved game found at #{file_path}"
      puts "Starting a new game"
      sleep(2)
      return
    rescue => error
      puts "An error occurred while loading the game: #{error.message}"
      exit(1)
    end
  end

  def save_game(file_path)
    file_path = File.join(GAME_SAVES_DIR, file_path)
    File.open(file_path, 'w') { |file| file.puts serialize_game_state}
    puts "Game saved to #{file_path}"

    loop do
      puts "Do you want to continue playing (C) or quit (Q)?"
      choice = gets.chomp.downcase
      case choice
      when 'c'
        puts "Continuing the game"
        break
      when 'q'
        puts "Quitting the game"
        exit
      else
        puts "Please enter a valid choice. (C) to continue or (Q) to quit."
      end
    end
  end

  def read_words_from_file(file_path)
    File.readlines(file_path, chomp: true)
  end

  def select_random_word()
    filtered_words = @words.select { |word| word.length >= 5 && word.length <= 12 }
    filtered_words.sample.downcase
  end

  def display_word
    displayed_word = @secret_word.chars.map do |char|
      @guessed_letters.include?(char) ? char : '_'
    end
    puts "Secret word: #{displayed_word.join(' ')}"
  end

  def handle_guess(guess)
    unless ('a'..'z').include?(guess) && guess.length == 1
      puts "Please enter a single letter."
      return
    end

    if @guessed_letters.include?(guess)
      puts "You've already guessed that letter."
      return
    end

    @guessed_letters << guess

    if @secret_word.include?(guess)
      puts "Correct guess!"
    else
      puts "Incorrect guess!"
      @remaining_guesses -= 1
    end
  end

  def game_over?
    @secret_word.chars.all? { |char| @guessed_letters.include?(char) } || @remaining_guesses.zero?
  end

  def display_result
    if @secret_word.chars.all? { |char| @guessed_letters.include?(char) }
      puts "Congratulations! You've guessed the word: #{@secret_word}"
    elsif @remaining_guesses.zero?
      puts "Sorry, you've run out of guesses. The word was: #{@secret_word}"
    end
  end

  def new_game
    @secret_word = select_random_word()
    @guessed_letters = []
    @remaining_guesses = 7
    puts "New game started."
  end

  def play
    puts "Welcome to Hangman! Would you like to start a new game (N) or load a saved game (L)?"
    choice = gets.chomp.downcase
    case choice
      when 'n'
        new_game
      when 'l'
        puts "Enter a file path/name to load the game:"
        file_path = gets.chomp
        load_game(file_path)
      else
        puts "Please enter a valid choice. (N) to start a new game or (L) to load a saved game."
        return
    end
    puts "The word has #{secret_word.length} letters."

    loop do
      display_word
      puts "Remaining guesses: #{@remaining_guesses}"
      puts "Enter a letter guess (or type 'save' to save the game):"
      guess = gets.chomp.downcase

      if guess =='save'
        puts "Enter a file path to save the game:"
        file_path = gets.chomp
        save_game(file_path)
        next
      end
      handle_guess(guess)
      break if game_over?
    end

    display_result
  end
end

hangman_game = Hangman.new('words.txt')
hangman_game.play
