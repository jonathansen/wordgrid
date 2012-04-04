require 'matrix'

class Matrix
  def find_cells_for_letter(letter)
    cells = []
    each_with_index(:all) do |e, row, column|
      if (e == letter)
        cell = [row, column]
        cells.push(cell)
      end
    end
    return cells
  end

  # why doesn't matrix natively support this?!?
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

class Wordgrid

  def initialize(initial_grid=Matrix[])
    self.grid = initial_grid
    @cell_stack = []
  end
  
  attr_reader :grid

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

  def has_word?(word)
    letters = word.split('')
    first_letter = letters.shift
    first_cells = @grid.find_cells_for_letter(first_letter)

    @cell_stack = []
    first_cells.each |cell| do
      @cell_stack.push(cell)
      if find_next_letter_in_neighborhood()
        return true
      end
      @cell_stack = []
    end
    return false
  end

=begin
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
    neighbors = @grid.neighbor_cells

  end
end
