class SudokuImage
  attr_reader :image_path, :image

  def initialize(params)
    @image_path=params[:image_path]
    @image=get_cv_image
    @scaled_image=scale_image(@image,600)
    @outlined_board=outline_board
    @win = GUI::Window.new "Display"
  end

  def get_cv_image
    CvMat::load @image_path
  end

  def display_image(image)
    @win.show image
    GUI::wait_key
  end

  def outline_board
    contours=getContours(@scaled_image)
    min_max_obj=getMinMaxBoxArea(image,0.5,1.0)
    box_array=[]
    contour_array=[]
    while contours
      unless contours.hole?
        box = contours.rect
        boxArea=box.width.to_f*box.height.to_f
        if (min_max_obj[:min]<boxArea) && (boxArea<=min_max_obj[:max])
          byebug
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
  def scale_image(image,newSize)
    temp_image = image.clone()
    size=temp_image.size
    oldHeight = size.height
    size.width=newSize*(size.width.to_f/oldHeight.to_f)
    size.height=newSize
    temp_image = temp_image.resize(size)
  end

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
  def isSquare(image)
    percent_difference=(Math.abs(image.height-image.width))/(image.height/2+image.width/2)
    byebug
    puts x
  end
end
