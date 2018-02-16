class TicTacToe
  def initialize
    @board = Board.new
    @player_one = Player.new("Player One", :x, @board)
    @player_two = Player.new("Player Two", :y, @board)
    @current_player = @player_one
  end

  def play
    loop do
      @board.render
      @current_player.get_coordinates
      break if check_game_over
      switch_players
    end
  end

  def check_game_over
    check_victory || check_tie
  end

  def check_victory
    if @board.winning_combination?(@current_player.piece)
      puts "Congrats #{@current_player}, you win!"
      true
    else
      false
    end
  end

  def check_tie
    if @board.full?
      puts "It's a tie."
      true
    else
      false
    end
  end

  def switch_players
    if @current_player == @player_one
      @current_player = @player_two
    else
      @current_player = @player_one
    end
  end
end

class Board
  def initialize
    @board = Array.new(3){Array.new(3)}
  end

  def render
    puts
    @board.each do |row|
      row.each do |cell|
        cell.nil? ? print("-") : print(cell.to_s)
      end
      puts
    end
    puts

  end

  def add_piece(coords, piece)
    if piece_location_valid?(coords)
      @board[coords[0]] [coords[1]] = piece
      true
    else
      false
    end
  end

  def piece_location_valid?(coords)
    if within_valid_coordinates?(coords)
      coordinates_available?(coords)
    end
  end

  def within_valid_coordinates?(coords)
    if (0..2).include?(coords[0]) && (0..2).include?(coords[1])
      true
    else
      puts "Piece coordinates are out of bounds"
    end
  end

  def coordinates_available?(coords)
    if @board[coords[0]][coords[1]].nil?
      true
    else
      puts "There is already a piece there!"
    end
  end

  def winning_combination?(piece)
    winning_diagonal?(piece) ||
    winning_horizontal?(piece) ||
    winning_vertical?(piece)
  end

  def winning_diagonal?(piece)
    diagonals.any? do |diag|
      diag.all? {|cell| cell == piece}
    end
  end

  def winning_vertical?(piece)
    verticals.any? do |vert|
      vert.all? {|cell| cell == piece}
    end
  end

  def winning_horizontal?(piece)
    horizontals.any? do |horz|
      horz.all? {|cell| cell == piece}
    end
  end

  def diagonals
    [[@board[0][0], @board[1][1], @board[2][2]], [@board[2][0], @board[1][1], @board[0][2] ]]
  end

  def verticals
    @board
  end

  def horizontals
    horizontals = []
    3.times do |i|
      horizontals << [@board[0][i], @board[1][i], @board[2][i]]
    end
    horizontals
  end

  def full?
    @board.all? do |row|
      row.none?(&:nil?)
    end
  end
end

class Player
  attr_accessor :name, :piece

  def initialize(name = "Mystery_Player", piece, board)
    raise "Piece must be a Symbol!" unless piece.is_a?(Symbol)
    @name = name
    @board = board
    @piece = piece
  end

  def get_coordinates
    loop do
      coords = ask_for_coordinates
      if validate_coordinates_format(coords)
        if @board.add_piece(coords, @piece)
          break
        end
      end
    end
  end

  def ask_for_coordinates
    puts "#{@name}(#{@piece}), enter your coordinates"
    gets.strip.split(",").map(&:to_i)
  end

  def validate_coordinates_format(coords)
    if coords.is_a?(Array) && coords.size == 2
      true
    else
      puts "Your coordinates are in an improper format!"
    end
  end
end


t = TicTacToe.new
t.play
