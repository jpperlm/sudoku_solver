class SudokuImage
  attr_reader: :imagePath

  def initialize(params)
    @imagePath=params[:image]
    @image=get_cv_image
  end

  def get_cv_image
    CvMat::load @image
  end
end
