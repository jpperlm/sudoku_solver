# Sudoku Solver
### *Coded By: Jason Perlman*
* [Jason Perlman](https://github.com/jpperlm)

### Use
In order to test the C Header files for openCV and the gem Ruby-Tesseract-OCR included.

File structure:
driver.rb -> /ruby/sudokuImage.rb -> /ruby/modules/*

### Description

A Ruby application that begins with a screenshot of a Sudoku puzzle and outputs a valid solution. The individual tiles of the board are detected using the openCV library. An algorithm loops through the tiles detecting which tiles contain a number. Tesseract OCR is used to translate the image containing a number into machine encoded text. The board is then solved and the final solution displayed on screen.

Technologies Used: Ruby, openCV, Tesseract OCR

### Example:
![Alt text](./images/gif.gif?raw=true "Example")
