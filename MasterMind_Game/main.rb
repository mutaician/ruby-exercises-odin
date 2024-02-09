

class Mastermind
  attr_accessor :secret_code
  def initialize(pegs_count, colors_count,attempts)
    @pegs_count = pegs_count
    @colors_count = colors_count
    @attempts = attempts
  end

  def generate_secret_code
    secret_code = []
    @pegs_count.times do
      peg_color = rand(1..@colors_count)
      secret_code << peg_color
    end
    secret_code
  end

  def display_instructions
    puts "Welcome to Mastermind!"
    puts "The objective of the game is to guess the secret code."
    puts "The secret code consists of #{@pegs_count} pegs, each with a color."
    puts "There are #{@colors_count} colors available for the pegs."
    puts "After each guess, you will receive feedback to help you refine your next guess."
    puts "A '+' peg indicates correct color in the correct position"
    puts "A '-' peg indicates correct color in wrong position"
    puts "A '.' peg indicates wrong peg "
    puts "Enter q to quit."
    puts "You have a #{@attempts} attempts to guess the secret code."
    puts "Let's begin!"
  end

  def get_user_guess
    guess = []
    puts "Enter your guess between (1 and #{@colors_count}) (e.g., 1234) (h for feedback help)"
    input = gets.chomp
    guess = input.split('').map(&:to_i)
    if input.downcase.include?('q')
      return "q"
    end


    while guess.include?(0) || guess.length != @pegs_count
      if input.downcase.include?('h')
        puts " '+'  indicates correct color in the correct position."
        puts " '-'  indicates correct color in wrong position."
        puts " '.'  indicates wrong peg."
        puts "Enter your guess "
      else
        puts "Invalid guess! Enter a valid number and #{@pegs_count} numbers."
      end
      input = gets.chomp
      guess = input.split('').map(&:to_i)
    end
    guess
  end

  def provide_feedback(guess)
    feedback = []
    guess.each_with_index do |peg, index|
      if peg == @secret_code[index]
        feedback << '+'
      elsif @secret_code.include?(peg)
        feedback << '-'
      else
        feedback << '.'
      end
    end
    puts "Feedback: #{feedback.join(' ')}"
  end

  def game_over?(guesses)
    return :win if guesses.last == @secret_code
    return :lose if guesses.length >= @attempts
    false #Game is still ongoing
  end

  def display_result(result)
    case result
    when :win
      puts "Congratulations! You guessed the secret code: #{@secret_code}"
    when :lose
      puts "Sorry, you ran out of attempts. The secret code was #{@secret_code}"
    end
  end

  def start_game
    display_instructions
    game_is_on = true
    while true
      @secret_code = generate_secret_code
      p secret_code
      guesses = []
      attempts_remaining = @attempts
      loop do
        puts "Attempts remaining #{attempts_remaining}"

        guess = get_user_guess
        if guess == 'q'
          game_is_on = false
          break
        end
        guesses << guess

        provide_feedback(guess)

        result = game_over?(guesses)
        if result == :win || result == :lose
          display_result(result)
          break
        end
        attempts_remaining -= 1
      end
      break unless game_is_on

      puts "Do you want to play again? (yes/no)"
      play_again = gets.chomp
      if play_again.downcase.include?('n')
        puts "Thanks for playing"
        break
      end
    end

  end


end


pegs_count = 4
colors_count = 6
turns = 3
game = Mastermind.new(pegs_count, colors_count,turns)
game.start_game
