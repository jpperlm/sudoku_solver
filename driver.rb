require './app.rb'
win = GUI::Window.new "original"

image = CvMat::load "sudoku.jpg"
contours=getContours(image)
bounds=estimateBoxSize(image)
areaObj={
  min: bounds[:minSide]**2,
  max: bounds[:maxSide]**2
}
displayAllContoursOnImage(image,contours,win)
all81Boxes=find81Boxes(image,areaObj,contours)
numOrNullArray=hasNumber(all81Boxes,win)
reverseAndDisplay(numOrNullArray)
# displayAllContoursOnImage(image,filtContoursImages[:contours],win)

# image = RTesseract.new("sudoku.png")
# puts image.to_s # Getting the value
# tesse = Tesseract::Engine.new {|e|
# e.language  = :eng
# e.
# e.whitelist = '0123456789'
# }
# puts tesse.text_for('sudoku.png')

# win = GUI::Window.new "original"

# imageArray.each do |x|
#   win.show x
#   GUI::wait_key
# end
#Get Height and Width of Image
#Shrink Image to 500 pixels in height - for smaller handling speeds
# height = image.size.height
# width = image.size.width
# win = GUI::Window.new "window"
# win.show image
# GUI::wait_key
