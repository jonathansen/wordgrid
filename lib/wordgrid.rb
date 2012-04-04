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
  def neighbor_cells(row, column)
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
    if first_cells.size == 0
      return false
    end
# TODO, this is getting silly. figure out how to do this with recursion
    first_cells.each {|cell|
      letters.each { |letter|
        neighbors = @grid.neighbor_cells(cell[0], cell[1])
        neighbors.each{ |neighbor|
          if @grid.element(neighbor[0],neighbor[1]) == letter
        }
      }

    }
  end
end
