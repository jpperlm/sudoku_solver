require './requireFile.rb'
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

  return {
          minSide: smallSquareSideMin,
          maxSide: smallSquareSideMax
        }
end
def getContours(cvImage)
  greyImage = cvImage.BGR2GRAY
  morph = greyImage.morphology(CV_MOP_GRADIENT,IplConvKernel.new(3,3,0,0,:ellipse))
  threshMat=morph.threshold(0,255,CV_THRESH_BINARY,true)
  canny = threshMat[0].canny(50,150)
  contour = threshMat[0].find_contours(:mode => OpenCV::CV_RETR_LIST, :method => OpenCV::CV_CHAIN_APPROX_SIMPLE)
end

def filterContoursAndBoundingBoxes(image,areaMinMax,contours)
  filteredContours=[]
  boundingRectangles=[]
  while contours
    unless contours.hole?
      box = contours.bounding_rect
      if (areaMinMax[:min]<contours.contour_area) && (contours.contour_area<areaMinMax[:max])
        boundingRectangles.push(image.sub_rect(box))
        filteredContours.push(contours)
      end
    end
    contours = contours.h_next
  end
  return {
    images: boundingRectangles,
    contours: filteredContours
  }
  # contours = morphed.find_contours(options)
end

def displayAllContoursOnImage(image,contours,displayWin)
  tempImage=image.clone
  contours.each do |contour|
    unless contour.hole?
      box = contour.bounding_rect
      tempImage.rectangle! box.top_left, box.bottom_right, {:color => OpenCV::CvColor::Green, :thickness => 4}
    end
  end
  displayWin.show tempImage
  GUI::wait_key
end
##Next steps
#Check if there is a certain amount inside the image - if yes - then we know there is a number and do algorithm to figure otu what
#if no- skip and return null, don't run because back things happen when we do]
#maybe do same algorithm as above and find the smaller contour circling the number and then use this for OCR
def ocr(image,win)
  contours = getContours(image)
  displayAllContoursOnImage(image,contours,win)

  image = shrinkImage(image)
  # image.save_image('test.png')
  # win.show image
  # GUI::wait_key

  # tesse = Tesseract::Engine.new {|e|
  # e.language = :eng
  # e.page_segmentation_mode = 10
  # e.whitelist = '0123456789'
  # }
  # puts tesse.text_for('test.png')
end

def shrinkImage(image)
  size=image.size
  oldHeight = size.height
  size.width=30*(size.width.to_f/oldHeight.to_f)
  size.height=30
  image=image.erode(IplConvKernel.new(5,6,0,0,:rect))
  image = image.resize(size)
end
