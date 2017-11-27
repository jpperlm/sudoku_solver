require './requireFile.rb'
win = GUI::Window.new "a"

baseString="./images/"
i1="sudoku2.jpg"
i2="sudoku.png"
i3="sud3.jpg"
images_to_decode=[baseString+i1,baseString+i2,baseString+i3]
images_to_decode.each do |image|
  cvImage = CvMat::load image
  scaledImage=shrinkImageSize(cvImage,600)
  image_array = wrapperGuessBoard(scaledImage)
  numOrNullArray=hasNumber(image_array,win)
  board=changeFormatForSolve(numOrNullArray)
  x = solve(board)
  x.each do |x2|
    puts x2.join("")
  end
  puts "--------------"
end
