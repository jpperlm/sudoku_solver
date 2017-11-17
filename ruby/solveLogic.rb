# Takes a board as a string in the format
# you see in the puzzle file. Returns
# something representing a board after
# your solver has tried to solve it.
# How you represent your board is up to you!
def changeFormatForSolve(array)
  x=0
  y=2
  returnArray=[]
  (0..2).each do |times|
    x=0+(times*27)
    y=2+(times*27)
    (0..2).each do |row|
        val=row +(times*3)
        returnArray[val] = array[x..y]+array[x+(9)..y+(9)]+array[x+(18)..y+(18)]
        x+=3
        y+=3
    end
  end
  returnArray
end

def solve(board)
  # board = makeArrayFromString(board_string)
  start_location = [0,0]

  recursive_solve(start_location, board)
end
# Returns a boolean indicating whether
# or not the provided board is solved.
# The input board will be in whatever
# form `solve` returns.
def solved?(board)
  true_array = []
  board.each do |row|
    true_array << row.sort.join.include?("123456789")
  end

  board.transpose.each do |row|
    true_array << row.sort.join.include?("123456789")
  end
  boxes = [
          [[0,0], [0,1], [0,2], [1,0], [1,1], [1,2], [2,0], [2,1], [2,2]],
          [[0,3], [0,4], [0,5], [1,3], [1,4], [1,5], [2,3], [2,4], [2,5]],
          [[0,6], [0,7], [0,8], [1,6], [1,7], [1,8], [2,6], [2,7], [2,8]],
          [[3,0], [3,1], [3,2], [4,0], [4,1], [4,2], [5,0], [5,1], [5,2]],
          [[3,3], [3,4], [3,5], [4,3], [4,4], [4,5], [5,3], [5,4], [5,5]],
          [[3,6], [3,7], [3,8], [4,6], [4,7], [4,8], [5,6], [5,7], [5,8]],
          [[6,0], [6,1], [6,2], [7,0], [7,1], [7,2], [8,0], [8,1], [8,2]],
          [[6,3], [6,4], [6,5], [7,3], [7,4], [7,5], [8,3], [8,4], [8,5]],
          [[6,6], [6,7], [6,8], [7,6], [7,7], [7,8], [8,6], [8,7], [8,8]]]
boxes.each do |row_locations|
  box_array = []
  row_locations.each do |location|
    box_array << board[location[0]][location[1]]
  end
  true_array << box_array.sort.join.include?("123456789")
end

return true if !true_array.include?(false)


end

# Takes in a board in some form and
# returns a _String_ that's well formatted
# for output to the screen. No `puts` here!
# The input board will be in whatever
# form `solve` returns.
def pretty_board(board)
  board
end

def recursive_solve(location, board)
  # binding.pry
  #BASE CASE RETURN
  return true if !(board.join.include?("X"))
  return false if location[0] == 9
  # ARRAY OF NUMBERS TO TRY
  num_array = [1,2,3,4,5,6,7,8,9,10]
  if board[location[0]][location[1]] == "X"
    num_array.each do |num|
      return false if num ==10
      if check_row(location, board, num) && check_column(location, board, num) && check_box(location, board, num)
        board[location[0]][location[1]] = num.to_s
        if recursive_solve(nextLocation(location),board)
          return board
        else
          location = reverseLocation(location)
          board[location[0]][location[1]] = "X"
        end
      end
    end
    return false
  else
    recursive_solve(nextLocation(location),board)
  end
  location = reverseLocation(location)
  return false if (board.join.include?("X"))
  board
end
def nextLocation(location)
#Takes in location, returns next location in sudoku
  if location[1] < 8
    location[1] +=1
  else
    location[0] += 1
    location[1] = 0
  end
  location
end

def reverseLocation(location)
#Takes in location, returns next location in sudoku
  if location[1] == 0
    location[1] = 8
    location[0] -=1
  else
    location[1] -= 1
  end
  location
end

# iterates through board string and makes array of array
def makeArrayFromString(board_string)
  board_array = [[],[],[],[],[],[],[],[],[]]
  board_string.split("").map.with_index do |val,index|
    board_array[index/9] << val
  end
  board_array
end

def check_row(location, board, number)
  if board[location[0]].include?(number.to_s)
    return false
  end
  true
end

def check_column(location, board, number)
  board_transposed = board.transpose
  check_row(location.reverse, board_transposed, number.to_s)
end

def check_box(location, board, number)
  # check first box
  first_box_locations = [[0,0], [0,1], [0,2], [1,0], [1,1], [1,2], [2,0], [2,1], [2,2]]
  if first_box_locations.include?(location)
    first_box_locations.each do |box_location|
      unless box_location == location
        if board[box_location[0]][box_location[1]] == number.to_s
          return false
        end
      end
    end
    return true
  end

  # check second box
  second_box_locations = [[0,3], [0,4], [0,5], [1,3], [1,4], [1,5], [2,3], [2,4], [2,5]]
  if second_box_locations.include?(location)
    second_box_locations.each do |box_location|
      unless box_location == location
        if board[box_location[0]][box_location[1]] == number.to_s
          return false
        end
      end
    end
    return true
  end

  # check third box
  third_box_locations = [[0,6], [0,7], [0,8], [1,6], [1,7], [1,8], [2,6], [2,7], [2,8]]
  if third_box_locations.include?(location)
    third_box_locations.each do |box_location|
      unless box_location == location
        if board[box_location[0]][box_location[1]] == number.to_s
          return false
        end
      end
    end
    return true
  end

  # check fourth box
  fourth_box_locations = [[3,0], [3,1], [3,2], [4,0], [4,1], [4,2], [5,0], [5,1], [5,2]]
  if fourth_box_locations.include?(location)
    fourth_box_locations.each do |box_location|
      unless box_location == location
        if board[box_location[0]][box_location[1]] == number.to_s
          return false
        end
      end
    end
    return true
  end

  # check fifth box
  fifth_box_locations = [[3,3], [3,4], [3,5], [4,3], [4,4], [4,5], [5,3], [5,4], [5,5]]
  if fifth_box_locations.include?(location)
    fifth_box_locations.each do |box_location|
      unless box_location == location
        if board[box_location[0]][box_location[1]] == number.to_s
          return false
        end
      end
    end
    return true
  end

  # check sixth box
  sixth_box_locations = [[3,6], [3,7], [3,8], [4,6], [4,7], [4,8], [5,6], [5,7], [5,8]]
  if sixth_box_locations.include?(location)
    sixth_box_locations.each do |box_location|
      unless box_location == location
        if board[box_location[0]][box_location[1]] == number.to_s
          return false
        end
      end
    end
    return true
  end

  # check seventh box
  seventh_box_locations = [[6,0], [6,1], [6,2], [7,0], [7,1], [7,2], [8,0], [8,1], [8,2]]
  if seventh_box_locations.include?(location)
    seventh_box_locations.each do |box_location|
      unless box_location == location
        if board[box_location[0]][box_location[1]] == number.to_s
          return false
        end
      end
    end
    return true
  end

  # check eighth box
  eighth_box_locations = [[6,3], [6,4], [6,5], [7,3], [7,4], [7,5], [8,3], [8,4], [8,5]]
  if eighth_box_locations.include?(location)
    eighth_box_locations.each do |box_location|
      unless box_location == location
        if board[box_location[0]][box_location[1]] == number.to_s
          return false
        end
      end
    end
    return true
  end

  # check ninth box
  ninth_box_locations = [[6,6], [6,7], [6,8], [7,6], [7,7], [7,8], [8,6], [8,7], [8,8]]
  if ninth_box_locations.include?(location)
    ninth_box_locations.each do |box_location|
      unless box_location == location
        if board[box_location[0]][box_location[1]] == number.to_s
          return false
        end
      end
    end
    return true
  end
end
