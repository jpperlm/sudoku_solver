require './requireFile.rb'
win = GUI::Window.new "a"

image = CvMat::load "./images/sudoku.png"
image=shrinkImageSize(image,600)
image_array = guess81(guess9boxes(findLargeOutline(image)))
# image_array.each do |x|
#   win.show x
#   GUI::wait_key
# end

numOrNullArray=hasNumber(image_array,win)
displayBoxesOfNine(numOrNullArray)
# reverseAndDisplay(numOrNullArray)


# displayAllContoursOnImage(image,contours,win)
# all81Boxes=find81Boxes(image,areaObj,contours)
# numOrNullArray=hasNumber(all81Boxes,win)
# reverseAndDisplay(numOrNullArray)
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


#Get Height and Width of Image
#Shrink Image to 500 pixels in height - for smaller handling speeds
# height = image.size.height
# width = image.size.width
# win = GUI::Window.new "window"
# win.show image
# GUI::wait_key
