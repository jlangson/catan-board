# The class CatanBoard represents a Catan Board with no expansions
# A Catan board has 19 hexagons. Each hexagon has a roll and a resource on it. 
# Rolls that are 6's and 8's cannot be adjacent to other 6's and 8's
# The 'desert' square has no roll on it

RESOURCES = ['forest', 'forest', 'forest', 'forest', 'brick', 'brick', 'brick', 'wheat', 'wheat', 'wheat', 'wheat', 'sheep', 'sheep', 'sheep', 'sheep', 'stone', 'stone', 'stone'] # desert is left out because it isn't a resource and needs to be specially added

# note - there are 19 tiles, yet 18 rolls. This is because the desert tile does not get a roll. 
SPECIAL_ROLLS = [6, 6, 8, 8]
PLAIN_ROLLS = [2, 3, 3, 4, 4, 5, 5, 9, 9, 10, 10, 11, 11, 12]
TILES = (1..19).to_a
EMPTY_BOARD = Array.new(19) {Array.new(0) {[]}}
HARBORS = ['brick', 'generic', 'generic', 'generic', 'generic', 'sheep', 'stone', 'wheat', 'wood'] 

# this function returns the adjacent tiles on the catan board. 
# See the picture in "catan overview.odg" for details
def neighbors(loc)
  case loc
  when 1
    return [2, 4, 5]
  when 2
    return [1, 3, 5, 6]
  when 3
    return [2, 6, 7]
  when 4
    return [1, 5, 8, 9]
  when 5
    return [1, 2, 4, 6, 9, 10]
  when 6 
    return [2 , 3, 5, 7, 10, 11]
  when 7
    return [3, 6, 11, 12]
  when 8
    return [4, 9, 13]
  when 9
    return [4, 5, 8, 10, 13, 14]
  when 10
    return [5, 6, 9, 11, 14, 15]
  when 11
    return [6, 7, 10, 12, 15, 16]
  when 12
    return [7, 11, 16]
  when 13
    return [9, 14, 17]
  when 14
    return [9, 10, 13, 15, 17, 18]
  when 15
    return [10, 11, 14, 16, 18, 19]
  when 16
    return [11, 12, 15, 19]
  when 17
    return [13, 14, 18]
  when 18
    return [14, 15, 17, 19]
  when 19
    return [15, 16, 18]
  else
    return "error"
  end
end


class CatanBoard
  def initialize()

    # @board and @harbors are tha arrays that represent the games
    # The other variables are used to set up the board 
    @board = Array.new(EMPTY_BOARD) 
    @harbors = Array.new(HARBORS)  # @harbors[0] corresponds with A, while @harbors[8] corresponds with I in the harbor diagram in "catan overview.odg"
    @resources = Array.new(RESOURCES)
    @special_rolls = Array.new(SPECIAL_ROLLS)
    @plain_rolls = Array.new(PLAIN_ROLLS)
    @tiles = Array.new(TILES)

    # RANDOMIZE THE HARBORS #
    @harbors = @harbors.shuffle

    # PLACE THE SPECIAL ROLLS #
    temp_tiles = @tiles
    for i in (0..@special_rolls.length-1)
      loc = temp_tiles.delete_at(rand(temp_tiles.length)) # chooses a random tile as the location and saves it
            #temp_tiles.delete(loc) # I think this line isn't needed
      temp_tiles = temp_tiles - neighbors(loc)
    # puts the tile and the roll onto the board
      @board[i] << loc
      @board[i] << @special_rolls.pop 
      @tiles.delete(loc)
    end


    # THEN PLACE THE REST OF THE ROLLS #
    for i in (0..@tiles.length-1)
      loc = @tiles.delete_at(rand(@tiles.length))
      @board[i+4] << loc # +4 because loctions 0 through 3 are filled
      @board[i+4] << @plain_rolls.pop
    end


    # THEN PLACE THE RESOURCES #
    @board[@board.length-1] << 'desert' # matches the desert tile to the nil roll
    for r in (0..@resources.length-1)
      # removes a random resource and pairs it with a location and a roll
      # resources must be removed randomly otherwise the 6's and 8's are all on stone and sheep
      @board[r] << @resources.delete_at(rand(@resources.length)) 
    end

  end

  def board()
    return @board
  end

  def harbors()
    return @harbors
  end



  # This determines if the board is set up according to the game's rules
  def is_legal?()

    #TEST SPECIAL ROLLS#
    # special rolls are in first four locations
    for loc in (0..3)
      for other_loc in (0..3)
        if neighbors(@board[loc][0]).include?(!@board[other_loc][0])
          return false
        end
      end
    end

    #TEST TOTAL ROLLS#
    all_rolls = Array.new(SPECIAL_ROLLS + PLAIN_ROLLS)

    # extracts the rolls from board
    temp_rolls = []
    # -2 because the desert square doesn't have a roll and it is last in the array
    for i in (0..@board.length-2)
      temp_rolls << @board[i][1]
    end

    temp_rolls = temp_rolls.sort
    all_rolls = all_rolls.sort

    if temp_rolls != all_rolls
      temp_resources
      return false
    end


    #TEST RESOURCE AMOUNT#

    all_resources = Array.new(RESOURCES)
    temp_resources = []
    # -2 because the desert square isn't a resource and it is last in the array
    for i in (0..@board.length-2) 
      temp_resources << @board[i][2]
    end

    temp_resources = temp_resources.sort
    all_resources = all_resources.sort


    if temp_resources != all_resources
      return false
    end

    #TEST HARBORS#

    temp_harbors = Array.new(HARBORS)
    sorted_harbors = @harbors.sort

    if temp_harbors != sorted_harbors
      return false
    end
    
    return true
  end

end


