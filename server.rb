require 'sinatra'
require './lib/sudoku.rb'
require './lib/cell.rb'
require './lib/helpers.rb'
require 'sinatra/partial'
require 'rack-flash'

use Rack::Flash

set :partial_template_engine, :erb

enable :sessions

def random_sudoku
	seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
	sudoku = Sudoku.new(seed.join)
	sudoku.solve!
	puts sudoku
	sudoku.to_s.chars
end

def puzzle(sudoku)
	test = sudoku.dup
	until test.count(0) == 30
		test[(0..80).to_a.sample] = 0
	end
	test
end


get '/' do
	prepare_to_check_solution
	generate_new_puzzle_if_necessary
	@current_solution = session[:current_solution] || session[:puzzle]
	@solution = session[:solution]
	@puzzle = session[:puzzle]
	erb :index
end


get '/solution' do
  @current_solution = session[:solution]
  	@solution = session[:solution]
	@puzzle = session[:puzzle]
  erb :index
end

post '/' do
  cells = box_order_to_row_order(params["cell"])  
  session[:current_solution] = cells.map{|value| value.to_i }.join
  session[:check_solution] = true
  redirect to("/")
end

get '/new' do
	new_puzzle
	redirect to ("/")
end






def box_order_to_row_order(cells)

	box_indicies = ([0,3,6,27,30,33,54,57,60].map{ |i| [i, i+1, i+2, i+9, i+10, i+11,i+18, i+19, i+20]}).flatten
    box_indicies.map{|box_index| cells[box_index]}
end

def generate_new_puzzle_if_necessary
	return if session[:current_solution]
	sudoku = random_sudoku
	session[:solution] = sudoku
	session[:puzzle] = puzzle(sudoku)
	session[:current_solution] = session[:puzzle]
end

def prepare_to_check_solution
	@check_solution = session[:check_solution]
	if @check_solution 
		flash[:notice] = " Try again loser ! "
	else flash[:notice] = " "
	end
	session[:check_solution] = nil
end

def new_puzzle
	sudoku = random_sudoku
	session[:solution] = sudoku
	session[:puzzle] = puzzle(sudoku)
	session[:current_solution] = session[:puzzle]
end




  


























