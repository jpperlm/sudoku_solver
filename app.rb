require "rubygems"
require "opencv"
require 'byebug'
include OpenCV

#Given an image determine upper and lower bounds for the 3 squares
#A small square (81 of them)
#The 3x3 squares
#The Entire Board size
def estimateBoxSize(cvImage)
  imageHeight = cvImage.size.height
  imageWidth = cvImage.size.width

  largeSquareSideMax= imageWidth < imageHeight ? imageWidth : imageHeight
  largeSquareSideMin= largeSquareSideMax / 2

  mediumSquareSideMax=largeSquareSideMax/3
  mediumSquareSideMin=largeSquareSideMin/3

  smallSquareSideMax=largeSquareSideMax/9
  smallSquareSideMin=largeSquareSideMin/9

  return [smallSquareSideMin,smallSquareSideMax]
end

def findContours(cvImage)
    small = cvImage.pyr_down()
    greyImage = small.BGR2GRAY
    morph = greyImage.morphology(CV_MOP_GRADIENT,IplConvKernel.new(3,3,0,0,:ellipse))
    threshMat=morph.threshold(0,255,CV_THRESH_BINARY,true)
    canny = threshMat[0].canny(50,150)
    val=small.clone
    contour = threshMat[0].find_contours(:mode => OpenCV::CV_RETR_LIST, :method => OpenCV::CV_CHAIN_APPROX_SIMPLE)
    loopContoursRejectBySize(small,contour)
end

def loopContoursRejectBySize(image,contour)
  sizeBounds=estimateBoxSize(image)
  displayImage=image.clone
  while contour
    # No "holes" please (aka. internal contours)
    unless contour.hole?
      box = contour.bounding_rect
      # Draw that bounding rectangle
      puts contour.contour_area
      if (sizeBounds[0]**2<contour.contour_area) && (contour.contour_area<sizeBounds[1]**2)
        displayImage.rectangle! box.top_left, box.bottom_right, {:color => OpenCV::CvColor::Green, :thickness => 4}
      end
    end
    contour = contour.h_next
  end
  return [displayImage]
  # contours = morphed.find_contours(options)
end


win = GUI::Window.new "original"
image = CvMat::load "sudoku.png"
imageArray=findContours(image)
imageArray.each do |x|
  win.show x
  GUI::wait_key
end
#Get Height and Width of Image
#Shrink Image to 500 pixels in height - for smaller handling speeds
# height = image.size.height
# width = image.size.width
# win = GUI::Window.new "window"
# win.show image
# GUI::wait_key
