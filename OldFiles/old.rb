require './requireFile.rb'
# def findContours(cvImage)
#     # small = cvImage.pyr_down()
#     greyImage = cvImage.BGR2GRAY
#     morph = greyImage.morphology(CV_MOP_GRADIENT,IplConvKernel.new(3,3,0,0,:ellipse))
#     threshMat=morph.threshold(0,255,CV_THRESH_BINARY,true)
#     canny = threshMat[0].canny(50,150)
#     contour = threshMat[0].find_contours(:mode => OpenCV::CV_RETR_LIST, :method => OpenCV::CV_CHAIN_APPROX_SIMPLE)
#     loopContoursRejectBySize(cvImage,contour)
# end
#
#
# displayImage.rectangle! box.top_left, box.bottom_right, {:color => OpenCV::CvColor::Green, :thickness => 4}
tesse = Tesseract::Engine.new {|e|
e.language = :eng
e.page_segmentation_mode = 10
e.whitelist = '0123456789'
}
puts tesse.text_for('test.png')
