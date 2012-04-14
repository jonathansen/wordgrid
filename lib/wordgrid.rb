require 'matrix'

=begin
Wordgrid is useful for sucking the life out of games like Boggle or
Scramble with Friends. Given a matrix of letters, it provides a method
named has_word? which looks in the matrix for a requested word.

Paired with a driver script that iterates over a dictionary and checks
every single word to see if it matches, then you are provided with the
full list of words in the game. That would make the game a miserable
bore, but it was fun to write.
=end
class Wordgrid

# Wordgrid.new can optionally be called with a Matrix object.
  def initialize(initial_grid=Matrix[])
    self.grid = initial_grid
    @cell_stack = []
  end

# Wordgrid.grid is the underlying matrix of letters.
  attr_reader :grid

=begin
grid takes a Matrix object and validates that it is acceptable.

* *Args* :
  - +new_grid+ -> the proposed new Matrix object.
* *Returns* :
  - the Matrix object itself.
* *Raises* : +ArgumentError+ in the following circumstances:
  - any of the cells consist of something other than single letters
  - the grid is not a square
=end

  def grid=(new_grid)
    # make sure each cell is a single letter character
    bad_cell = new_grid.find_index{|cell| cell.match(/^[^A-Za-z]$/) }
    if bad_cell
      raise ArgumentError "Bad cell at " + bad_cell.to_s
    end

    unless new_grid.square?
      raise ArgumentError "grid must be a square." # do I really care about this?
    end

    @grid = new_grid
  end

=begin
has_word? is Wordgrid's raison d'être. It take a word and returns
true/false based on whether the word can be found in the grid.

has_word? makes sure not to re-trace its steps when looking for a word.
So, for example, it will find "BEAD" in the following grid, but it will
not find "BEADED":
  A B C
  D E F
  G H I

* *Args* :
  - +word+ -> the word to search the grid for
* *Returns* :
  - +true+, if the word has been found, and +false+ otherwise
* *Raises* :
  - Nothing
=end
  def has_word?(word)
    @letters = word.split('')
    first_cells = @grid.find_cells_for_letter(@letters[0])

    @cell_stack = []
    first_cells.each do |cell|
      @cell_stack.push(cell)
      if find_next_letter_in_neighborhood() == true
        return true
      end
      @cell_stack = []
    end
    return false
  end

=begin
find_next_letter_in_neighborhood calls itself recursively to look for
each letter in the word. One it finds the word, it stop the recursive
chain returning true. It follows the following plan:

1. start with a cell
2. look at all the neighbors of the cell for the next letter.
  if we don't find it, move back up to try a different path (if there were other matches a cell up)
  if we do find it
    if we're at the end of the string, stop, and return true
    if we aren't at the end of the string, goto 2 for the cell we found

along the way, build a stack of the path. So for the following grid:
  A B C
  D E F
  G H I
a final stack for "BEAD" should be: [0,1], [1,1], [0,0], [1,0]

=end
  def find_next_letter_in_neighborhood
    if (@cell_stack.size == @letters.size)
      return true
    end
    neighbors = @grid.neighbor_cells(@cell_stack[-1])
    current_letter = @letters[@cell_stack.size]
    neighbors.each do |neighbor|
      # don't retraverse nodes on the path we've taken thus far.
      if @cell_stack.find { |cell| cell == neighbor }
        next
      end

      neighbor_letter = @grid.element(neighbor[0], neighbor[1])
      if neighbor_letter == current_letter
        @cell_stack.push(neighbor)
        if find_next_letter_in_neighborhood == true
          return true
        end
      end
    end
    @cell_stack.pop
    return false
  end
  private :find_next_letter_in_neighborhood
end

# Adding two helper functions to the standard Matrix class which are
# needed by the Wordgrid class.
class Matrix

=begin
Adds a method to the Matrix class which returns an array of cells
which match the string passed in. A cell is just an array with the
row and column.

* *Args* :
  - +letter+ -> the character to search the matrix for.
* *Returns* :
  - the cells which match the letter passed in. An array of two-value arrays.
* *Raises* :
  - Nothing
=end

  def find_cells_for_letter(letter)
    cells = []
    each_with_index do |e, row, column|
      if (e == letter)
        cell = [row, column]
        cells.push(cell)
      end
    end
    return cells
  end

=begin
Adds a method to the Matrix class which will find all the cells which
border the cell requested

Neighbors are defined by the cells northwest, north, northeast, west,
east, southwest, south, and southeast of the original cell. If the
original cell is on the edge of the matrix, it does not wrap. In
other words, for the following matrix:
  A B C
  D E F
  G H I
the cell containing the letter E has the neighbors A,B,C,D,F,G,H,I.
However, the cell containing the letter A only has the neighbors
B,D,E.

* *Args* :
  - +root_cell+ -> a two-element array (row, cell) identifying the cell whose neighbors we are seeking.
* *Returns* :
  - an array of cells (each cell is a two-element array, containing row and cell) neighboring the original cell.
* *Raises* :
  - Nothing
=end

  def neighbor_cells(root_cell)
    row = root_cell[0]
    column = root_cell[1]
    cells = []

    cells.push([row-1, column-1]) if row-1 >= 0 and column-1 >= 0 #NW
    cells.push([row-1, column]) if row-1 >= 0 #N
    cells.push([row-1, column+1]) if row-1 >= 0 and column+1 < column_size #NE
    cells.push([row, column-1]) if column-1 >=0 #W
    cells.push([row, column+1]) if column+1 < column_size #E
    cells.push([row+1, column-1]) if row+1 < row_size and column-1 >= 0 #SW
    cells.push([row+1, column]) if row+1 < row_size #S
    cells.push([row+1, column+1]) if row+1 < row_size and column+1 < column_size #SE

    return cells
  end
end

