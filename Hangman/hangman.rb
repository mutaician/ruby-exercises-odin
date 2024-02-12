# Hangman

# Read words from text file into an array
def read_words_from_file(filepath)
  File.readlines(filepath, chomp: true)
end

# Select random word from array
def select_random_word(words)
  filtered_words = words.select { |word| word.length >= 5 && word.length <= 12 }
  filtered_words.sample.downcase
end

# display current state of the word with guessed leters revealed
def display_word(secret_word, guessed_letters)
  displayed_word = secret_word.chars.map do |letter|
    guessed_letters.include?(letter)? letter : "_"
  end
  puts "Secret word: #{displayed_word.join(' ')}"
end


def main_game
  words = read_words_from_file("words.txt")
  secret_word = select_random_word(words)
  p secret_word

  guessed_letters = []
  remaining_guesses = 7
  puts "Welcome to Hangman! Try to guess the secret word."
  puts "The word has #{secret_word.length} letters."

  loop do
    display_word(secret_word, guessed_letters)
    puts "Enter a letter guess: "
    guess = gets.chomp.downcase
    # validate user input
    unless ('a'..'z').include?(guess) && guess.length == 1
      puts "Invalid guess. Please enter a single letter."
      next
    end

    if guessed_letters.include?(guess)
      puts "You already guessed that letter."
      next
    end
    # update guessed letters
    guessed_letters << guess
    # check for correct guess
    if secret_word.include?(guess)
      puts 'Correct guess!'
    else
      remaining_guesses -= 1
      puts "Incorrect guess. You have #{remaining_guesses} guesses remaining."
    end
    # check for wins or losses
    if secret_word.chars.all? { |letter| guessed_letters.include?(letter) }
      puts "Congratulations! You've guessed the word: #{secret_word}"
      break
    elsif remaining_guesses.zero?
      puts "Sorry You've run out of guesses. The word was: #{secret_word}"
      break
    end
  end
end

main_game
