require 'matrix'
require 'wordgrid'

describe Wordgrid, "#grid" do
  it "stores a matrix of single letters" do
    wordgrid = Wordgrid.new
    grid = Matrix[
      [ "a", "b", "c" ],
      [ "d", "e", "f" ],
      [ "g", "h", "i" ]
    ]
    wordgrid.set_grid(grid)
    wordgrid.get_grid.should eq(grid)
  end
end
