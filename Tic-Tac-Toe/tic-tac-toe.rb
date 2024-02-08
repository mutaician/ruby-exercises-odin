# frozen_string_literal: true

class Board
  def initialize
    @grid = Array.new(3) { Array.new(3, ' ') }
  end

  def display
    @grid.each do |row|
      puts row.join(' | ')
      puts '-' * 9
    end
  end

  def place_mark(row, col, mark)
    if valid_move?(row, col)
      @grid[row][col] = mark
      true
    else
      false
    end
  end

  def valid_move?(row, col)
    row.between?(0, 2) && col.between?(0, 2) && @grid[row][col] == ' '
  end

  attr_reader :grid

  def reset
    @grid = Array.new(3) { Array.new(3, ' ') }
  end
end

class TicTacToe
  def initialize
    @board = Board.new
    @current_player = 'X'
    @game_is_on = true
  end

  def play
    loop do
      @board.reset
      @current_player = %w[X O].sample

      loop do
        @board.display
        row, col = get_player_move
        if row.nil? || col.nil?
          @game_is_on = false
          break
        end

        if @board.place_mark(row, col, @current_player)
          if winner?(@current_player)
            puts "Player #{@current_player} wins!"
            @board.display
            break
          elsif board_full?
            puts 'Draw'
            break
          else
            switch_player
          end
        end
      end
      break unless @game_is_on

      puts 'Do you want to play again? (yes/no) '
      choice = gets.chomp.downcase
      break unless choice.include?('y')
    end
    puts 'Thanks for playing'
  end

  def get_player_move
    loop do
      puts "Player #{@current_player}'s turn. Enter your move (1-9), or type 'quit' to end the game:"
      input = gets.chomp.downcase

      if input.include?('q')
        return nil, nil
      elsif input.length == 1 && ('1'..'9').include?(input)
        position = input.to_i - 1
        row = position / 3
        col = position % 3
        return row, col if @board.valid_move?(row, col)

        puts 'Invalid move! Please enter a valid move.'

      else
        puts 'Invalid input! Please enter a single digit (1-9).'
      end
    end
  end

  def switch_player
    @current_player = @current_player == 'X' ? 'O' : 'X'
  end

  def winner?(player)
    winning_lines = [
      [[0, 0], [0, 1], [0, 2]], # Rows
      [[1, 0], [1, 1], [1, 2]],
      [[2, 0], [2, 1], [2, 2]],
      [[0, 0], [1, 0], [2, 0]], # Columns
      [[0, 1], [1, 1], [2, 1]],
      [[0, 2], [1, 2], [2, 2]],
      [[0, 0], [1, 1], [2, 2]], # Diagonals
      [[0, 2], [1, 1], [2, 0]]
    ]
    winning_lines.any? do |line|
      line.all? { |row, col| @board.grid[row][col] == player }
    end
  end

  def board_full?
    @board.grid.all? { |row| row.all? { |cell| cell != ' ' } }
  end
end

game = TicTacToe.new
game.play
