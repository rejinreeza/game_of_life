class HomeController < ApplicationController
  def index
#     role_ids = Array.new
    @patterns= [nil,'blinker - oscillator','toad - oscillator','beacon - oscillator','pulsar - oscillator' ]
    @cls = [[],[[9,8],[9,9],[9,10]]]
  end
  def submit
    cell = params[:role_ids]
    @lives = cell.collect { |c| c.split(/\s/).collect{ |s| s.to_i } }
    @lives = find_new_live(@lives)
     respond_to do |format|
       format.json { render :json => @lives }
#       format.xml { render :xml => @people.to_xml }
    end
  end
  
  def find_neighbours(arr)
  return [ [ arr[0]+1,arr[1] ], [ arr[0],arr[1]+1 ], [arr[0]-1, arr[1] ],
           [ arr[0],arr[1]-1 ], [ arr[0]+1,arr[1]+1 ], [ arr[0]-1,arr[1]-1 ], 
           [ arr[0]-1,arr[1]+1 ],[ arr[0]+1,arr[1]-1 ]]
  end
  
  def finding_window(arr)
    x_arr =Array.new
    y_arr =Array.new
    arr.each do |a| 
      x_arr << a[0]
      y_arr << a[1]
    end
    start_point = [x_arr.min-1,y_arr.min-1]
    end_point = [x_arr.max+1,y_arr.max+1]
    [start_point,end_point]
  end

  def find_new_live(live)
    window = finding_window(live)
    new_live = live.dup
    for x_axis in window[0][0]..window[1][0]
      for y_axis in window[0][1]..window[1][1]
	if live.include?([x_axis,y_axis])
	  neighbours = find_neighbours([x_axis,y_axis])
	  live_neighbours = neighbours & live
	  if live_neighbours.count < 2 || live_neighbours.count > 3
	    new_live.delete([x_axis,y_axis])	   
	  end
	else
	  neighbours = find_neighbours([x_axis,y_axis])
	  live_neighbours = neighbours & live
	  if live_neighbours.count == 3
	    new_live << [x_axis,y_axis] 
	  end
	end
      end
    end
    new_live
  end
  
end
