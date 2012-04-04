require 'matrix'

class Wordgrid
  def initialize(initial_grid=Matrix[])
    @grid = initial_grid
  end
  
  attr_reader :grid

  def grid=(new_grid)
    # make sure each cell is a single letter character
    bad_cell = new_grid.find_index{|cell| cell.match(/^[^A-Za-z]$/) }
    if bad_cell
      raise ArgumentError "Bad cell at " + bad_cell.to_s
    end

    unless new_grid.square?
      raise ArgumentError "grid must be a square."
    end

    @grid = new_grid
  end
end
