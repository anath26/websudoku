require 'sinatra'
require './lib/sudoku.rb'
require './lib/cell.rb'

enable :sessions

def random_sudoku
	seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
	sudoku = Sudoku.new(seed.join)
	sudoku.solve!
	puts sudoku
	sudoku.to_s.chars
end

def puzzle(sudoku)
	sudoku
end


get '/solution' do 
	@current_solution = session[:solution]
	erb :index
end

post '/' do
	cells = box_order_to_row(params["cell"])
	session[:current_solution] = cells.maps{|value| value_to.i}.join
	session[:check] = true
	redirect to("/")
end

def box_order_to_row(cells)
	boxes = cells.reach_slice(9).to_a
	(0..8).to_a.inject([]) {|memo, i|
		first_box_index = i / 3 * 3
		three_boxes = boxes[first_box_index, 3]
		three_rows_of_three = three_boxes.map do |box|
			row_number_in_a_box = i % 3
			first_cell_in_the_row_index = row_number_in_a_box * 3
			box[first_cell_in_the_row_index, 3]
			end
			memo += three_rows_of_the_three.flatten
		}
end






