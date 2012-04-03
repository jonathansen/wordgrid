require 'matrix'

class Wordgrid
  def initialize
    @grid = Matrix[]
  end
  
  def grid=(new_grid)
    @grid = new_grid
  end
  def grid
    @grid
  end
end
