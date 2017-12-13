module ImageHelpers
  def get_cv_image(imagePath)
    CvMat::load imagePath
  end

  def get_scaled_image(image,newSize)
    size=image.size
    oldHeight = size.height
    size.width=newSize*(size.width.to_f/oldHeight.to_f)
    size.height=newSize
    image.resize(size)
  end
  #Rotates Image (Android Camera displayed sideways)
  def rotateAndFlip(image)
    return image.transpose.flip
  end
end
