class SudokuImage
  include BoxHelpers
  include ImageHelpers
  include SolveLogic
  attr_reader :imagePath,:image,:scaledImage,:imageArray, :translatedArray

  def initialize(params)
    @imagePath=params[:image]
    @image=get_cv_image(@imagePath)
    @scaledImage=get_scaled_image(@image,600)
    @imageArray=wrapper(@scaledImage)
    @translatedArray=hasNumber(@imageArray)
    @formattedArray=changeFormatForSolve(@translatedArray)
    @solvedBoard=solve(cloneArray(@formattedArray))
  end


  def displaySolvedBoard
    displayBoard(@solvedBoard)
  end
  def displayInputBoard
    displayBoard(@formattedArray)
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
