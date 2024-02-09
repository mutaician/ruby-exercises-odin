
class ComputerPlayer
  attr_reader :pegs_count, :colors_count
  def initialize(pegs_count, colors_count)
    @pegs_count = pegs_count
    @colors_count = colors_count
  end

  def generate_guess_2(user_secret_code,turns)
    computer_guess = [1,2,3,4]
    guess_range = (1..@colors_count).to_a
    g_times = 0
    while turns > 0
      puts "Computer guessing #{computer_guess}"
      if computer_guess == user_secret_code
        puts "Computer wins in #{g_times}"
        break
      end

      computer_guess.each do |num_code|
        if !user_secret_code.include?(num_code)
          guess_range.reject! { |num| num == num_code}
        end
      end

      

      computer_guess = []
      @pegs_count.times do
        computer_guess << guess_range.sample
      end
      g_times += 1
    end
  end

  def generate_guess
    guess = []
    @pegs_count.times do
      guess << rand(1..@colors_count)
    end
    guess
  end

  def guess_users_secret_code(user_secret_code, turns)
    p "computer quessing #{user_secret_code}"
    g_times = 0
    while turns > 0
      computer_guess = generate_guess
      puts "Computer guessed #{computer_guess}"
      if computer_guess == user_secret_code
        puts "Computer wins in #{g_times} turns"
        break
      end
      g_times += 1
    end
    puts "Computer loses" if turns < 1
  end

end


class Mastermind
  def initialize(pegs_count, colors_count,attempts, user_secret_code = false)
    @pegs_count = pegs_count
    @colors_count = colors_count
    @attempts = attempts
    @user_secret_code = user_secret_code

    if user_secret_code
      @secret_code = get_user_code
      computer = ComputerPlayer.new(@pegs_count,@colors_count)
      computer.generate_guess_2(@secret_code, @attempts)
    end
  end

  def generate_secret_code
    secret_code = []
    @pegs_count.times do
      peg_color = rand(1..@colors_count)
      secret_code << peg_color
    end
    secret_code
  end

  def get_user_code
    puts "Enter the secret code(e.g,1234) between (1 and #{@colors_count}):"
    input = gets.chomp
    user_secret_code = input.split('').map(&:to_i)
    while user_secret_code.include?(0) || user_secret_code.length != @pegs_count
      puts "Invalid code. Try again"
      input = gets.chomp
      user_secret_code = input.split('').map(&:to_i)
    end
    user_secret_code

  end

  def display_instructions
    puts "The objective of the game is to guess the secret code."
    puts "The secret code consists of #{@pegs_count} holes, each with a color."
    puts "There are #{@colors_count} colors available for the holes."
    puts "After each guess, you will receive feedback to help you refine your next guess."
    puts "A '+' hole indicates correct color in the correct position"
    puts "A '-' hole indicates correct color in wrong position"
    puts "A '.' hole indicates wrong hole "
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

  def provide_feedback(guess,secret_code)
    feedback = []
    guess.each_with_index do |peg, index|
      if peg == secret_code[index]
        feedback << '+'
      elsif secret_code.include?(peg)
        feedback << '-'
      else
        feedback << '.'
      end
    end
    puts "Feedback: #{feedback.join(' ')}"
  end

  def game_over?(guesses,secret_code)
    return :win if guesses.last == secret_code
    return :lose if guesses.length >= @attempts
    false #Game is still ongoing
  end

  def display_result(result,secret_code)
    case result
    when :win
      puts "Congratulations! You guessed the secret code: #{secret_code}"
    when :lose
      puts "Sorry, you ran out of attempts. The secret code was #{secret_code}"
    end
  end

  def start_game
    display_instructions
    game_is_on = true
    while true
      secret_code = generate_secret_code
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

        provide_feedback(guess,secret_code)

        result = game_over?(guesses,secret_code)
        if result == :win || result == :lose
          display_result(result,secret_code)
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
turns = 12

puts "Welcome to Mastermind"
puts "Do you want to create the secret code or guess it?"
puts "Enter 'c' to create or 'g' to guess:"
choice = gets.chomp.strip.downcase

case choice
when 'c'
  #create secret code
  Mastermind.new(pegs_count, colors_count, turns, true)
when 'g'
  game = Mastermind.new(pegs_count, colors_count,turns)
  game.start_game
else
  puts "Invalid choice."
end
