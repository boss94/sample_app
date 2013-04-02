# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  before_filter :load_page, :only => [:show, :edit, :update, :destroy]

  def home
  	@titre = "Accueil"
    @homepage = Page.find_by_title("homepage")
  end

  def inventory
  	@titre = "Inventory"
  end

  def contact
  	@titre = "Contact"
  end

  def about
    @titre = t("pages.about_us")
#  	@titre = t (:about_us), :scope => [:pages]
  end
end
