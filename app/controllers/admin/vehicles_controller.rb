# encoding : utf-8
class Admin::VehiclesController < BeautifulController

  before_filter :load_vehicle, :only => [:show, :edit, :update, :destroy]

  # Uncomment for check abilities with CanCan
  #authorize_resource

  def index
    session[:fields] ||= {}
    session[:fields][:vehicle] ||= (Vehicle.columns.map(&:name) - ["id"])[0..4]
    do_select_fields(:vehicle)
    do_sort_and_paginate(:vehicle)
    
    @q = Vehicle.search(
      params[:q]
    )

    @vehicle_scope = @q.result(
      :distinct => true
    ).sorting(
      params[:sorting]
    )
    
    @vehicle_scope_for_scope = @vehicle_scope.dup
    
    unless params[:scope].blank?
      @vehicle_scope = @vehicle_scope.send(params[:scope])
    end
    
    @vehicles = @vehicle_scope.paginate(
      :page => params[:page],
      :per_page => 20
    ).all

    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json{
        render :json => @vehicle_scope.all 
      }
      format.csv{
        require 'csv'
        csvstr = CSV.generate do |csv|
          csv << Vehicle.attribute_names
          @vehicle_scope.all.each{ |o|
            csv << Vehicle.attribute_names.map{ |a| o[a] }
          }
        end 
        render :text => csvstr
      }
      format.xml{ 
        render :xml => @vehicle_scope.all 
      }             
      format.pdf{
        pdfcontent = PdfReport.new.to_pdf(Vehicle,@vehicle_scope)
        send_data pdfcontent
      }
    end
  end

  def show
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

  def new
    @vehicle = Vehicle.new

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

  def edit
    
  end

  def create
    #debugger 
    #hack to ignor the make_id posted by the form
    params[:vehicle].delete(:make_id)
    @vehicle = Vehicle.create(params[:vehicle])

    respond_to do |format|
      if @vehicle.save
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_vehicles_path(:mass_inserting => true)
          else
            redirect_to admin_vehicle_path(@vehicle), :notice => t(:create_success, :model => "vehicle")
          end
        }
        format.json { render :json => @vehicle, :status => :created, :location => @vehicle }
      else
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_vehicles_path(:mass_inserting => true), :error => t(:error, "Error")
          else
            render :action => "new"
          end
        }
        format.json { render :json => @vehicle.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    #hack to ignor the make_id posted by the form
    params[:vehicle].delete(:make_id)
    respond_to do |format|
      if @vehicle.update_attributes(params[:vehicle])
        format.html { redirect_to admin_vehicle_path(@vehicle), :notice => t(:update_success, :model => "vehicle") }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @vehicle.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @vehicle.destroy

    respond_to do |format|
      format.html { redirect_to admin_vehicles_url }
      format.json { head :ok }
    end
  end

  def batch
    attr_or_method, value = params[:actionprocess].split(".")

    @vehicles = []    
    
    Vehicle.transaction do
      if params[:checkallelt] == "all" then
        # Selected with filter and search
        do_sort_and_paginate(:vehicle)

        @vehicles = Vehicle.search(
          params[:q]
        ).result(
          :distinct => true
        )
      else
        # Selected elements
        @vehicles = Vehicle.find(params[:ids].to_a)
      end

      @vehicles.each{ |vehicle|
        if not Vehicle.columns_hash[attr_or_method].nil? and
               Vehicle.columns_hash[attr_or_method].type == :boolean then
         vehicle.update_attribute(attr_or_method, boolean(value))
         vehicle.save
        else
          case attr_or_method
          # Set here your own batch processing
          # vehicle.save
          when "destroy" then
            vehicle.destroy
          end
        end
      }
    end
    
    redirect_to :back
  end

  def treeview

  end

  def treeview_update
    modelclass = Vehicle
    foreignkey = :vehicle_id

    render :nothing => true, :status => (update_treeview(modelclass, foreignkey) ? 200 : 500)
  end
  
  private 
  
  def load_vehicle
    @vehicle = Vehicle.find(params[:id])
  end
end

