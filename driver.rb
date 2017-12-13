require './requireFile.rb'

baseString="./images/"
# images=["sudoku2.jpg","sudoku.png","sud3.jpg"]
images=["sudoku.png"]
images_to_decode=images.map{|e| baseString+e}
images_to_decode.each do |imagePath|
  sudokuImage = SudokuImage.new({image: imagePath})
  sudokuImage.displaySolvedBoard
  sudokuImage.displayInputBoard
end
