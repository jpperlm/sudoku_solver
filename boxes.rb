def findLargeOutline(image)
  contours=getContours(image)
  min_max_obj=getMinMaxBoxArea(image,0.5,1.0)
  box_array=[]
  win = GUI::Window.new "abc"
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
  byebug
  return imageArray
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
