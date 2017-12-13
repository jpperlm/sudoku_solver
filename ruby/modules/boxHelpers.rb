module BoxHelpers
  def wrapper(image)
    boardOutline = outlineBoard(image)
    sections = guess9boxes(boardOutline)
    allBoxes = guess9Looper(sections)
  end

  def outlineBoard(image)
    contours = contours(image)
    min_max_obj = calulatePercentArea(image,0.5,1.0)
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

  def contours(cvImage)
    greyImage = cvImage.BGR2GRAY
    morph = greyImage.morphology(CV_MOP_GRADIENT,IplConvKernel.new(3,3,0,0,:ellipse))
    threshMat=morph.threshold(0,255,CV_THRESH_BINARY,true)
    canny = threshMat[0].canny(50,150)
    contour = threshMat[0].find_contours(:mode => OpenCV::CV_RETR_LIST, :method => OpenCV::CV_CHAIN_APPROX_SIMPLE)
  end
  #Takes an image and two percent values (0-1.0)
  #Calculates the area of the image. Returns an object
  #with the area multiplied by the min/max precents
  def calulatePercentArea(image,min,max)
    height = image.size.height
    width = image.size.width
    shorter_side = width < height ? width : height
    max_side=shorter_side*max
    min_side= shorter_side * min
    return {
      min: min_side**2,
      max: max_side**2
    }
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

  def hasNumber(images)
    outPutArray=[]
    images.each do |image|
      contours = contours(image)
      areaObj=areaPercentages(image)
      filtContoursImages=filterContoursAndBoundingBoxes(image,areaObj,contours)
      boxes = filtContoursImages[:rectangles]
      boxes.sort! do |a,b|
        a.width*a.height<b.width*b.height ? 1 : 0
      end
      boxes.select! do |a|
        (a.height>a.width)
      end

      if boxes.length==0
        outPutArray.push("X")
      else
        newImage=image.sub_rect(boxes[0])
        newImage=newImage.copy_make_border(:constant,CvSize.new(newImage.size.width*2,newImage.size.height*2), CvPoint.new(newImage.size.width/2.0, newImage.size.height/2.0), 255)
        ocrText= ocr(newImage)
        if ocrText==""
          newImage = newImage.BGR2GRAY
          newImage=newImage.erode(IplConvKernel.new(2,2,0,0,:rect))
          ocrText= ocr(newImage)
          if ocrText==""
            ocrText="E"
          end
        end
        outPutArray.push(ocrText)
      end
    end
    outPutArray
  end

  def areaPercentages(image)
    imageHeight = image.size.height
    imageWidth = image.size.width
    area=imageWidth*imageHeight
    return {
      min: area*0.1,
      max: area*0.8
    }
  end

  def filterContoursAndBoundingBoxes(image,areaMinMax,contours)
    filteredContours=[]
    imageArray=[]
    rectangles=[]
    while contours
      unless contours.hole?
        box = contours.bounding_rect
        area= box.height*box.width
        if (areaMinMax[:min]<area) && (area<areaMinMax[:max])
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
  end
  def ocr(image)
    image.save_image('test.png')
    tesse = Tesseract::Engine.new {|e|
    e.language = :eng
    e.page_segmentation_mode = 10
    e.whitelist = '0123456789'
    }
    return tesse.text_for('test.png').strip()
  end
end
