class VehiclesController < ApplicationController
	load_and_authorize_resource
	# before_filter :load_vehicle, :only => [:show, :edit, :update, :destroy]

	def index
		@titre = "Inventory"

		@vehicles = Vehicle.all

		respond_to do |format|
			format.html{
				if request.headers['X-PJAX']
					render :layout => false
				else
					render
				end
			}
		end
	end

	def show
		#TODO: include make 
		@titre = (@vehicle.model.nil? ? "" : @vehicle.model.caption)
		respond_to do |format|
			format.html{
				if request.headers['X-PJAX']
					render :layout => false
				else
					render
				end
			}
			format.json { render :json => @vehicle }
		end
	end

	#onLoad
	def load_vehicle
		@vehicle = Vehicle.find(params[:id])
	end
end
