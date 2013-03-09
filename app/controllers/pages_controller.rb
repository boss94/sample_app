# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  def home
  	@titre = "Accueil"
  end

  def inventory
  	@titre = "Inventory"
  end

  def contact
  	@titre = "Contact"
  end

  def about
  	@titre = "À Propos"
  end
end
