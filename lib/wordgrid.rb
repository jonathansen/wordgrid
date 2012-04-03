require 'matrix'

class Wordgrid
  def initialize
    @grid = Matrix[]
  end
  
  def set_grid(new_grid)
    @grid = new_grid
  end

  def get_grid
    @grid
  end
end
