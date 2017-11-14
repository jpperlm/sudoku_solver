def detectBoard(image)
  gray = image.BGR2GRAY
  pattern_size = CvSize.new(16, 16)
  corners, found = gray.find_chessboard_corners(pattern_size, CV_CALIB_CB_ADAPTIVE_THRESH)
  byebug
  if found
    corners = gray.find_corner_sub_pix(corners, CvSize.new(3, 3), CvSize.new(-1, -1), CvTermCriteria.new(20, 0.03))
  end

  result = image.draw_chessboard_corners(pattern_size, corners, found)
  w = GUI::Window.new('Result')
  w.show result
  GUI::wait_key
end
