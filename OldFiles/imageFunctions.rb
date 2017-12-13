#Rescales image to a new size
def shrinkImageSize(image,newSize)
  size=image.size
  oldHeight = size.height
  size.width=newSize*(size.width.to_f/oldHeight.to_f)
  size.height=newSize
  image = image.resize(size)
end

#Rotates Image (Android Camera displayed sideways)
def rotateAndFlip(image)
  return image.transpose.flip
end
