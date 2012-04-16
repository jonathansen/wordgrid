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
    wordgrid.grid = grid
    wordgrid.grid.should eq(grid)
  end

  it "will let you set a grid in the constructor" do
    grid = Matrix[
      [ "a", "b", "c" ],
      [ "d", "e", "f" ],
      [ "g", "h", "i" ]
    ]
    wordgrid = Wordgrid.new(grid)
    wordgrid.grid.should eq(grid)
  end

  it "throws an error if any of the cells are numbers" do
    wordgrid = Wordgrid.new
    grid = Matrix[
      [ "a", "b", "c" ],
      [ "d", "9", "f" ],
      [ "g", "h", "i" ]
    ]

    expect { wordgrid.grid = grid }.to raise_error
  end

  it "throws an error if any of the cells are not letters" do
    wordgrid = Wordgrid.new
    grid = Matrix[
      [ "a", "b", "c" ],
      [ "d", "e", "f" ],
      [ "g", "~", "i" ]
    ]

    expect { wordgrid.grid = grid }.to raise_error
  end

  it "throws an error if the grid is not a square" do
    wordgrid = Wordgrid.new
    grid = Matrix[
      [ "a", "b", "c", "j" ],
      [ "d", "e", "f", "k" ],
      [ "g", "h", "i", "l" ]
    ]

    expect { wordgrid.grid = grid }.to raise_error
  end

  it "validates the grid even if you set it in the constructor" do
    grid = Matrix[
      [ "a", "b", "c" ],
      [ "d", "e", "f" ],
      [ "g", "~", "i" ]
    ]

    expect { wordgrid = Wordgrid.new(grid) }.to raise_error
  end

  it "lowercases all the letters in the grid" do
    grid = Matrix[
      [ "A", "b", "c" ],
      [ "d", "E", "f" ],
      [ "g", "h", "I" ]
    ]

    lc_grid = Matrix[
      [ "a", "b", "c" ],
      [ "d", "e", "f" ],
      [ "g", "h", "i" ]
    ]

    wordgrid = Wordgrid.new(grid)
    wordgrid.grid.should eq(lc_grid)
  end
end

describe Wordgrid, "#find_word" do
  grid = Matrix[
    [ "a", "b", "c" ],
    [ "d", "e", "f" ],
    [ "a", "b", "c" ]
  ]
  it "should find a word in a grid" do
    wordgrid = Wordgrid.new(grid)
    wordgrid.has_word?("bead").should eq(true)
  end

  it "shouldn't find a word that isn't in the grid" do
    wordgrid = Wordgrid.new(grid)
    wordgrid.has_word?("spaceman").should eq(false)
  end

  it "shouldn't think it found a word if it repeats a cell to do so" do
    wordgrid = Wordgrid.new(grid)
    wordgrid.has_word?("beaded").should eq(false)
  end

  it "shouldn't think it found a word if it only found part of it" do
    wordgrid = Wordgrid.new(grid)
    wordgrid.has_word?("beady").should eq(false)
  end
end
