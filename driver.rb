require './requireFile.rb'
win = GUI::Window.new "a"

image = CvMat::load "./images/sudoku.png"
image=shrinkImageSize(image,600)
image_array = wrapperGuessBoard(image)

numOrNullArray=hasNumber(image_array,win)
# displayBoxesOfNine(numOrNullArray)
board=changeFormatForSolve(numOrNullArray)
x = solve(board)
x.each do |x2|
  puts x2.join("")
end
