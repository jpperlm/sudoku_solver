def find81Boxes(image)
  contours=getContours(image)
  displayAllContoursOnImage(image,contours,win)
  areaMinMax=estimateBoxSize(image)
  imageArray=[]
  while contours
    unless contours.hole?
      box = contours.bounding_rect
      boxArea=box.width*box.height
      if (areaMinMax[:min]<boxArea) && (boxArea<areaMinMax[:max])
        imageArray.push(image.sub_rect(box))
      end
    end
    contours = contours.h_next
  end
  return imageArray
end

def getContours2nd(cvImage)
  greyImage = cvImage.BGR2GRAY
  morph = greyImage.morphology(CV_MOP_GRADIENT,IplConvKernel.new(3,3,0,0,:ellipse))
  # threshMat=morph.threshold(0,255,CV_THRESH_BINARY,true)
  ia=[greyImage,morph]
  contour = morph.find_contours(:mode => OpenCV::CV_RETR_LIST, :method => OpenCV::CV_CHAIN_APPROX_SIMPLE)
end

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
    min: smallSquareSideMin**2,
    max: smallSquareSideMax**2
  }
end
