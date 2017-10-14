#Given an image determine upper and lower bounds for the 3 squares
#A small square (81 of them)
#The 3x3 squares
#The Entire Board size

def numOutlineSize(cvImage)
  imageHeight = cvImage.size.height
  imageWidth = cvImage.size.width

  max= imageWidth < imageHeight ? imageWidth-5 : imageHeight-5
  min= max / 8
  return {
          minSide: min,
          maxSide: max
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
  imageArray=[]
  rectangles=[]
  while contours
    unless contours.hole?
      box = contours.bounding_rect
      if (areaMinMax[:min]<contours.contour_area) && (contours.contour_area<areaMinMax[:max])
        imageArray.push(image.sub_rect(box))
        filteredContours.push(contours)
        rectangles.push(box)
      end
    end
    contours = contours.h_next
  end
  return {
    numContours: filteredContours.size,
    images: imageArray,
    contours: filteredContours,
    rectangles: rectangles
  }
  # contours = morphed.find_contours(options)
end

def displayAllContoursOnImage(image,contours,displayWin)
  while contours
    unless contours.hole?
      box = contours.bounding_rect
      image.rectangle! box.top_left, box.bottom_right, {:color => OpenCV::CvColor::Green, :thickness => 4}
    end
    contours = contours.h_next
  end
  displayWin.show image
  GUI::wait_key
end

def displayAllBoxesOnImage(image,boxes,displayWin)
  tempImage=image.clone
  boxes.each do |box|
    tempImage.rectangle! box.top_left, box.bottom_right, {:color => OpenCV::CvColor::Green, :thickness => 4}
    displayWin.show tempImage
    GUI::wait_key
  end

end

def hasNumber(images,win)
  outPutArray=[]
  images.each do |image|
    contours = getContours(image)
    bounds=numOutlineSize(image)
    areaObj={
      min: bounds[:minSide]**2,
      max: bounds[:maxSide]**2
    }
    filtContoursImages=filterContoursAndBoundingBoxes(image,areaObj,contours)
    boxes = filtContoursImages[:rectangles]
    boxes.sort! do |a,b|
      a.width*a.height<b.width*b.height ? 1 : 0
    end
    # Here we are can either add '1' if length isn't 0 meaning there is a number in the box
    # or we add 0 meaning there wasnt anything in the box - we can turn this into an array in order to do OCR
    # or we can just do OCR here which might be best.
    if boxes.length==0
      outPutArray.push("x")
    else
      expandedBox=expandBox(boxes[0])
      ocrText= ocr(image.sub_rect(expandedBox),win)
      outPutArray.push(ocrText)
    end
    # displayAllBoxesOnImage(image,filtContoursImages[:rectangles],win)
  end
  outPutArray
end
#have to create checks to make sure these values are not negative
def expandBox(box)
  box.x=box.x-10
  box.width=box.width+20
  return box
end
def reverseAndDisplay(array)
  array.reverse!
  counter=0
  string=""
  array.each do |x|
    if counter==8
      puts string+x
      string=x
      counter=1
    else
      string=string+x
      counter=counter+1
    end
  end
end

##Next steps
#Check if there is a certain amount inside the image - if yes - then we know there is a number and do algorithm to figure otu what
#if no- skip and return null, don't run because back things happen when we do]
#maybe do same algorithm as above and find the smaller contour circling the number and then use this for OCR
def ocr(image,win)
  image=image.copy_make_border(:constant,CvSize.new(image.size.width+10,image.size.height+10), CvPoint.new(5, 5), 255)
    # win.show image
    # GUI::wait_key
  image.save_image('test.png')
  tesse = Tesseract::Engine.new {|e|
  e.language = :eng
  e.page_segmentation_mode = 10
  e.whitelist = '0123456789'
  }
  return tesse.text_for('test.png').strip()
end
def shrinkImageSize(image,newSize)
  image=image.transpose.flip
  size=image.size
  oldHeight = size.height
  size.width=newSize*(size.width.to_f/oldHeight.to_f)
  size.height=newSize
  image = image.resize(size)
end
def shrinkImage(image)
  size=image.size
  oldHeight = size.height
  size.width=30*(size.width.to_f/oldHeight.to_f)
  size.height=30
  image=image.erode(IplConvKernel.new(9,9,0,0,:rect))
  image = image.resize(size)
end
