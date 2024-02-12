class Hangman
  attr_reader :secret_word, :guessed_letters, :remaining_guesses

  def initialize(words_file_path)
    @words = read_words_from_file(words_file_path)
    @secret_word = select_random_word()
    @guessed_letters = []
    @remaining_guesses = 6
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

  def play
    puts "Welcome to Hangman! Try to guess the secret word."
    puts "The word has #{secret_word.length} letters."

    loop do
      display_word
      puts "Remaining guesses: #{@remaining_guesses}"
      puts "Enter a letter guess:"
      guess = gets.chomp.downcase
      handle_guess(guess)
      break if game_over?
    end

    display_result
  end
end

hangman_game = Hangman.new('words.txt')
hangman_game.play
