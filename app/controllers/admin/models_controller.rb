# encoding : utf-8
class Admin::ModelsController < BeautifulController

  before_filter :load_model, :only => [:show, :edit, :update, :destroy]

  # Uncomment for check abilities with CanCan
  #authorize_resource

  def index
    session[:fields] ||= {}
    session[:fields][:model] ||= (Model.columns.map(&:name) - ["id"])[0..4]
    do_select_fields(:model)
    do_sort_and_paginate(:model)
    
    @q = Model.search(
      params[:q]
    )

    @model_scope = @q.result(
      :distinct => true
    ).sorting(
      params[:sorting]
    )
    
    @model_scope_for_scope = @model_scope.dup
    
    unless params[:scope].blank?
      @model_scope = @model_scope.send(params[:scope])
    end
    
    @models = @model_scope.paginate(
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
        render :json => @model_scope.all 
      }
      format.csv{
        require 'csv'
        csvstr = CSV.generate do |csv|
          csv << Model.attribute_names
          @model_scope.all.each{ |o|
            csv << Model.attribute_names.map{ |a| o[a] }
          }
        end 
        render :text => csvstr
      }
      format.xml{ 
        render :xml => @model_scope.all 
      }             
      format.pdf{
        pdfcontent = PdfReport.new.to_pdf(Model,@model_scope)
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
      format.json { render :json => @model }
    end
  end

  def new
    @model = Model.new

    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json { render :json => @model }
    end
  end

  def edit
    
  end

  def create
    @model = Model.create(params[:model])

    respond_to do |format|
      if @model.save
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_models_path(:mass_inserting => true)
          else
            redirect_to admin_model_path(@model), :notice => t(:create_success, :model => "model")
          end
        }
        format.json { render :json => @model, :status => :created, :location => @model }
      else
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_models_path(:mass_inserting => true), :error => t(:error, "Error")
          else
            render :action => "new"
          end
        }
        format.json { render :json => @model.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @model.update_attributes(params[:model])
        format.html { redirect_to admin_model_path(@model), :notice => t(:update_success, :model => "model") }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @model.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @model.destroy

    respond_to do |format|
      format.html { redirect_to admin_models_url }
      format.json { head :ok }
    end
  end

  def batch
    attr_or_method, value = params[:actionprocess].split(".")

    @models = []    
    
    Model.transaction do
      if params[:checkallelt] == "all" then
        # Selected with filter and search
        do_sort_and_paginate(:model)

        @models = Model.search(
          params[:q]
        ).result(
          :distinct => true
        )
      else
        # Selected elements
        @models = Model.find(params[:ids].to_a)
      end

      @models.each{ |model|
        if not Model.columns_hash[attr_or_method].nil? and
               Model.columns_hash[attr_or_method].type == :boolean then
         model.update_attribute(attr_or_method, boolean(value))
         model.save
        else
          case attr_or_method
          # Set here your own batch processing
          # model.save
          when "destroy" then
            model.destroy
          end
        end
      }
    end
    
    redirect_to :back
  end

  def treeview

  end

  def treeview_update
    modelclass = Model
    foreignkey = :model_id

    render :nothing => true, :status => (update_treeview(modelclass, foreignkey) ? 200 : 500)
  end
  
  private 
  
  def load_model
    @model = Model.find(params[:id])
  end
end

