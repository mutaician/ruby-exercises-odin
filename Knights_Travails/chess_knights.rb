
class ChessBoard
  attr_reader :adjacency_list
  def initialize
    @adjacency_list = {}
    build_graph
  end

  def knight_moves(start_square, destination_square)
    path = shortest_path(start_square, destination_square)
    puts "You made it in #{path.length - 1} moves! Here's your path:"
    path.each { |square| puts square.inspect }
  end

  def build_graph
    (0..7).each do |row|
      (0..7).each do |col|
        square = [row,col]
        @adjacency_list[square] = []
      end
    end
    add_knight_moves
  end

  def add_knight_moves
    moves = [[1,2],[2,1],[-1,2],[-2,1],[-1,-2],[-2,-1],[1,-2],[2,-1]]
    @adjacency_list.each do |square, _|
      row, col = square
      moves.each do |dr, dc|
        new_row = row + dr
        new_col = col + dc
        if new_row.between?(0,7) && new_col.between?(0,7)
          @adjacency_list[square] << [new_row, new_col]
        end
      end
    end
  end

  def shortest_path(start_square, destination_square)
    visited = {} #keep track of visited squares
    queue = [] #store squares to be visited
    path = {} #reconstruct shortest path

    queue << start_square
    visited[start_square] = true

    while !queue.empty?
      current_square = queue.shift
      return reconstruct_path(path, start_square, destination_square) if current_square == destination_square
      @adjacency_list[current_square].each do |neighbor|
        unless visited[neighbor]
          queue << neighbor
          visited[neighbor] = true
          path[neighbor] = current_square
        end
      end
    end
  end

  def reconstruct_path(path, start_square, destination_square)
    current_square = destination_square
    shortest_path = []

    until current_square == start_square
      shortest_path.unshift(current_square)
      current_square = path[current_square]
    end
    shortest_path.unshift(start_square)
  end

end



graph = ChessBoard.new
graph.knight_moves([0,0],[7,7])
