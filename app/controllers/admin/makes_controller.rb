# encoding : utf-8
class Admin::MakesController < BeautifulController

  before_filter :load_make, :only => [:show, :edit, :update, :destroy]

  # Uncomment for check abilities with CanCan
  #authorize_resource

  def index
    session[:fields] ||= {}
    session[:fields][:make] ||= (Make.columns.map(&:name) - ["id"])[0..4]
    do_select_fields(:make)
    do_sort_and_paginate(:make)
    
    @q = Make.search(
      params[:q]
    )

    @make_scope = @q.result(
      :distinct => true
    ).sorting(
      params[:sorting]
    )
    
    @make_scope_for_scope = @make_scope.dup
    
    unless params[:scope].blank?
      @make_scope = @make_scope.send(params[:scope])
    end
    
    @makes = @make_scope.paginate(
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
        render :json => @make_scope.all 
      }
      format.csv{
        require 'csv'
        csvstr = CSV.generate do |csv|
          csv << Make.attribute_names
          @make_scope.all.each{ |o|
            csv << Make.attribute_names.map{ |a| o[a] }
          }
        end 
        render :text => csvstr
      }
      format.xml{ 
        render :xml => @make_scope.all 
      }             
      format.pdf{
        pdfcontent = PdfReport.new.to_pdf(Make,@make_scope)
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
      format.json { render :json => @make }
    end
  end

  def new
    @make = Make.new

    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json { render :json => @make }
    end
  end

  def edit
    
  end

  def create
    @make = Make.create(params[:make])

    respond_to do |format|
      if @make.save
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_makes_path(:mass_inserting => true)
          else
            redirect_to admin_make_path(@make), :notice => t(:create_success, :model => "make")
          end
        }
        format.json { render :json => @make, :status => :created, :location => @make }
      else
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_makes_path(:mass_inserting => true), :error => t(:error, "Error")
          else
            render :action => "new"
          end
        }
        format.json { render :json => @make.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @make.update_attributes(params[:make])
        format.html { redirect_to admin_make_path(@make), :notice => t(:update_success, :model => "make") }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @make.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @make.destroy

    respond_to do |format|
      format.html { redirect_to admin_makes_url }
      format.json { head :ok }
    end
  end

  def batch
    attr_or_method, value = params[:actionprocess].split(".")

    @makes = []    
    
    Make.transaction do
      if params[:checkallelt] == "all" then
        # Selected with filter and search
        do_sort_and_paginate(:make)

        @makes = Make.search(
          params[:q]
        ).result(
          :distinct => true
        )
      else
        # Selected elements
        @makes = Make.find(params[:ids].to_a)
      end

      @makes.each{ |make|
        if not Make.columns_hash[attr_or_method].nil? and
               Make.columns_hash[attr_or_method].type == :boolean then
         make.update_attribute(attr_or_method, boolean(value))
         make.save
        else
          case attr_or_method
          # Set here your own batch processing
          # make.save
          when "destroy" then
            make.destroy
          end
        end
      }
    end
    
    redirect_to :back
  end

  def treeview

  end

  def treeview_update
    modelclass = Make
    foreignkey = :make_id

    render :nothing => true, :status => (update_treeview(modelclass, foreignkey) ? 200 : 500)
  end
  
  private 
  
  def load_make
    @make = Make.find(params[:id])
  end
end

