def wrapperGuessBoard(image)
  boardOutline = outlineBoard(image)
  sections = guess9boxes(boardOutline)
  allBoxes = guess9Looper(sections)
end

def outlineBoard(image)
  contours=getContours(image)
  min_max_obj=getMinMaxBoxArea(image,0.5,1.0)
  box_array=[]
  contour_array=[]
  # win = GUI::Window.new "abc"
  # displayAllContoursOnImage(image,contours,win)
  while contours
    unless contours.hole?
      box = contours.rect
      boxArea=box.width.to_f*box.height.to_f
      if (min_max_obj[:min]<boxArea) && (boxArea<=min_max_obj[:max])
        box_array.push(box)
        perimeter=contours.arc_length
        val=perimeter*0.01
        approx=contours.approx_poly(:method=>:db, :accuracy=>val,:recursive =>false)
        if approx.size==4
          newImage=transformImage(image,approx)
          break
        end
      end
    end
    contours = contours.h_next
  end
  if newImage
    return newImage
  else
    return image
  end
end

#For a given image finds the locations of 9 sub square-sections
def guess9boxes(image)
  x = image.width/3
  y = image.height/3
  tl=CvRect.new(0,0,x,y)
  tc=CvRect.new(x,0,x,y)
  tr=CvRect.new(2*x,0,x,y)
  cl=CvRect.new(0,y,x,y)
  cm=CvRect.new(x,y,x,y)
  cr=CvRect.new(2*x,y,x,y)
  bl=CvRect.new(0,2*y,x,y)
  bc=CvRect.new(x,2*y,x,y)
  br=CvRect.new(2*x,2*y,x,y)
  box_array=[tl,tc,tr,cl,cm,cr,bl,bc,br]
  sectioned_images=[]
  box_array.each do |box|
    sectioned_images.push(image.sub_rect(box))
    # image.rectangle! box.top_left, box.bottom_right, {:color => OpenCV::CvColor::Green, :thickness => 4}
  end
  return sectioned_images
end
#Calls
def guess9Looper(imageArray)
  all81images=[]
  imageArray.each do |image|
    all81images.concat(guess9boxes(image))
  end
  return all81images
end

def getContours(cvImage)
  greyImage = cvImage.BGR2GRAY
  morph = greyImage.morphology(CV_MOP_GRADIENT,IplConvKernel.new(3,3,0,0,:ellipse))
  threshMat=morph.threshold(0,255,CV_THRESH_BINARY,true)
  canny = threshMat[0].canny(50,150)
  contour = threshMat[0].find_contours(:mode => OpenCV::CV_RETR_LIST, :method => OpenCV::CV_CHAIN_APPROX_SIMPLE)
end


def transformImage(image,approx)
  points=getCoords(approx)
  #Bl,TL,BR,TR
  tl=points[0]
  tr=points[1]
  br=points[2]
  bl=points[3]
  wa1 = (br.x-bl.x)**2
  wa2 = (br.y-bl.y)**2
  widthA=Math.sqrt(wa1+wa2)
  wb1 = (tr.x-tl.x)**2
  wb2 = (tr.y-tl.y)**2
  widthB=Math.sqrt(wb1+wb2)
  maxWidth=widthA<widthB ? widthA : widthB
  maxWidth=maxWidth.to_i
  ha1 = (tr.x-br.x)**2
  ha2 = (tr.y-br.y)**2
  heightA=Math.sqrt(ha1+ha2)
  hb1 = (tl.x-bl.x)**2
  hb2 = (tl.y-bl.y)**2
  heightB=Math.sqrt(hb1+hb2)
  maxHeight=heightA<heightB ? heightA : heightB
  maxHeight=maxHeight.to_i
  dst=[]
  dst[0] = CvPoint2D32f.new(0, 0);
  dst[1] = CvPoint2D32f.new(maxWidth,0);
  dst[2] = CvPoint2D32f.new(maxWidth,maxHeight);
  dst[3] = CvPoint2D32f.new(0,maxHeight);
  win = GUI::Window.new "ccc"

  transform = CvMat::get_perspective_transform(points,dst)
  box = CvRect.new(0,0,maxWidth,maxHeight)
  warpedImage=image.warp_perspective(transform).sub_rect(box)
end

def getCoords(contour)
  sorted = contour.sort_by {|point| [point.x, point.y] }
  if (sorted[0].y>sorted[1].y)
    bl=sorted[0];
    tl=sorted[1];
  else
    bl=sorted[1];
    tl=sorted[0];
  end
  if (sorted[2].y>sorted[3].y)
    br=sorted[2];
    tr=sorted[3];
  else
    br=sorted[3];
    tr=sorted[2];
  end
  returnArr=[]
  [tl,tr,br,bl].each do |point|
    returnArr.push(CvPoint2D32f.new(point.x,point.y))
  end
  returnArr

end

def isSquare(box)
  percent_difference= (box.length.to_f-box.width.to_f)/(box.length.to_f)
  return percent_difference<0.1
end

#Takes an image and two percent valeues (0-1.0)
#Returns an object with the min and max area
def getMinMaxBoxArea(cv_image,min,max)
  image_height = cv_image.size.height
  image_width = cv_image.size.width

  smaller_side = image_width < image_height ? image_width : image_height
  max_side_length=smaller_side*max
  min_side_length= smaller_side * min

  return {
    min: min_side_length**2,
    max: max_side_length**2
  }
end
