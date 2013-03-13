# encoding : utf-8
class Admin::PagesController < BeautifulController

  before_filter :load_page, :only => [:show, :edit, :update, :destroy]

  # Uncomment for check abilities with CanCan
  #authorize_resource

  def index
    session[:fields] ||= {}
    session[:fields][:page] ||= (Page.columns.map(&:name) - ["id"])[0..4]
    do_select_fields(:page)
    do_sort_and_paginate(:page)
    
    @q = Page.search(
      params[:q]
    )

    @page_scope = @q.result(
      :distinct => true
    ).sorting(
      params[:sorting]
    )
    
    @page_scope_for_scope = @page_scope.dup
    
    unless params[:scope].blank?
      @page_scope = @page_scope.send(params[:scope])
    end
    
    @pages = @page_scope.paginate(
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
        render :json => @page_scope.all 
      }
      format.csv{
        require 'csv'
        csvstr = CSV.generate do |csv|
          csv << Page.attribute_names
          @page_scope.all.each{ |o|
            csv << Page.attribute_names.map{ |a| o[a] }
          }
        end 
        render :text => csvstr
      }
      format.xml{ 
        render :xml => @page_scope.all 
      }             
      format.pdf{
        pdfcontent = PdfReport.new.to_pdf(Page,@page_scope)
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
      format.json { render :json => @page }
    end
  end

  def new
    @page = Page.new

    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json { render :json => @page }
    end
  end

  def edit
    
  end

  def create
    @page = Page.create(params[:page])

    respond_to do |format|
      if @page.save
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_pages_path(:mass_inserting => true)
          else
            redirect_to admin_page_path(@page), :notice => t(:create_success, :model => "page")
          end
        }
        format.json { render :json => @page, :status => :created, :location => @page }
      else
        format.html {
          if params[:mass_inserting] then
            redirect_to admin_pages_path(:mass_inserting => true), :error => t(:error, "Error")
          else
            render :action => "new"
          end
        }
        format.json { render :json => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to admin_page_path(@page), :notice => t(:update_success, :model => "page") }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @page.destroy

    respond_to do |format|
      format.html { redirect_to admin_pages_url }
      format.json { head :ok }
    end
  end

  def batch
    attr_or_method, value = params[:actionprocess].split(".")

    @pages = []    
    
    Page.transaction do
      if params[:checkallelt] == "all" then
        # Selected with filter and search
        do_sort_and_paginate(:page)

        @pages = Page.search(
          params[:q]
        ).result(
          :distinct => true
        )
      else
        # Selected elements
        @pages = Page.find(params[:ids].to_a)
      end

      @pages.each{ |page|
        if not Page.columns_hash[attr_or_method].nil? and
               Page.columns_hash[attr_or_method].type == :boolean then
         page.update_attribute(attr_or_method, boolean(value))
         page.save
        else
          case attr_or_method
          # Set here your own batch processing
          # page.save
          when "destroy" then
            page.destroy
          end
        end
      }
    end
    
    redirect_to :back
  end

  def treeview

  end

  def treeview_update
    modelclass = Page
    foreignkey = :page_id

    render :nothing => true, :status => (update_treeview(modelclass, foreignkey) ? 200 : 500)
  end
  
  private 
  
  def load_page
    @page = Page.find(params[:id])
  end
end

