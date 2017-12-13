class SudokuImage
  include BoxHelpers
  include ImageHelpers
  include SolveLogic
  attr_reader :imagePath,:image,:scaledImage,:imageArray, :translatedArray

  def initialize(params)
    @imagePath=params[:image]
    @image=get_cv_image(@imagePath)
    @emptyBoardImage=get_cv_image("./images/emptySudoku.png")
    @scaledImage=get_scaled_image(@image,600)
    @imageArray=wrapper(@scaledImage)
    @translatedArray=hasNumber(@imageArray)
    @formattedArray=changeFormatForSolve(@translatedArray)
    @solvedBoard=solve(cloneArray(@formattedArray))
    @win = GUI::Window.new "window"

  end


  def displaySolvedBoard
    displayBoard(@solvedBoard)
  end
  def displayInputBoard
    displayBoard(@formattedArray)
  end

  def displayPrettyBoard
    returnImage = @emptyBoardImage.clone
    yincrement =(@emptyBoardImage.size.height-7)/9
    y = yincrement/(-8)
    xincrement=(@emptyBoardImage.size.width-5)/9
    x=xincrement/(-2)
    @solvedBoard.each do |row|
      y+=yincrement
      x=xincrement/(-1.5)
      row.each do |item|
        x+=xincrement
        point = CvPoint.new(x,y)
        font = OpenCV::CvFont.new(:simplex, :hscale => 2, :vslace => 2, :bold => true)
        returnImage.put_text!(item,point,font,CvColor::Black)
      end
    end
    @win.show returnImage
    GUI::wait_key
  end


  private

  def displayBoard(board)
    board.each do |tile|
      puts tile.join("")
    end
  end
  def cloneArray(array)
    returnArray=[]
    array.each_with_index do |arr,i|
      returnArray.push([])
      arr.each do |num|
        returnArray[i].push(num)
      end
    end
    return returnArray
  end

end
