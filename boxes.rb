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
  box_array.each do |box|
    image.rectangle! box.top_left, box.bottom_right, {:color => OpenCV::CvColor::Green, :thickness => 4}
  end
  win = GUI::Window.new "be"
  win.show image
  GUI::wait_key
end

def findLargeOutline(image)
  contours=getContours(image)
  min_max_obj=getMinMaxBoxArea(image,0.5,1.0)
  box_array=[]
  # win = GUI::Window.new "abc"
  # displayAllContoursOnImage(image,contours,win)
  while contours
    unless contours.hole?
      box = contours.bounding_rect
      boxArea=box.width.to_f*box.height.to_f
      if (min_max_obj[:min]<boxArea) && (boxArea<min_max_obj[:max])
        box_array.push(box)
      end
    end
    contours = contours.h_next
  end
  return image.sub_rect(box_array[0])
end


def isSquare(box)
  percent_difference= (box.length.to_f-box.width.to_f)/(box.length.to_f)
  return percent_difference<0.1
end
def sortArrayOfImage
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
