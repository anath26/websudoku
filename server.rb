require 'sinatra'
require './lib/sudoku.rb'
require './lib/cell.rb'

def random_sudoku
	seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
	sudoku = Sudoku.new(seed.join)
	sudoku.solve!
	puts sudoku
	sudoku.to_s.chars
end

get '/' do 
	@current_solution = random_sudoku
	erb :index
end