# Sudoku Solver
### *Coded By: Jason Perlman*
* [Jason Perlman](https://github.com/jpperlm)

### Use
In order to use this one must install the C Header files for [openCV](https://github.com/ruby-opencv/ruby-opencv) and the gem Ruby-Tesseract-OCR.

File structure:
driver.rb -> /ruby/sudokuImage.rb -> /ruby/modules/*

### Description

A Ruby application that begins with a screenshot of a Sudoku puzzle and outputs a valid solution. The individual tiles of the board are detected using the openCV library. An algorithm loops through the tiles detecting which tiles contain a number. Tesseract OCR is used to translate the image containing a number into machine encoded text. The board is then solved and the final solution displayed on screen.

Technologies Used: Ruby, openCV, Tesseract OCR

### Example:
![Example](https://user-images.githubusercontent.com/12966977/47436274-2dd65700-d774-11e8-83f9-723c5f604ca3.gif)
