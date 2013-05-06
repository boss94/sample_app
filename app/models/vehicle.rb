class Vehicle < ActiveRecord::Base
  include BeautifulScaffoldModule      
  has_many :images
  before_save :fulltext_field_processing
  validates :model, :color, :presence => true

  def fulltext_field_processing
    # You can preparse with own things here
    generate_fulltext_field(["equipment","notes"])
  end
  scope :sorting, lambda{ |options|
    attribute = options[:attribute]
    direction = options[:sorting]

    attribute ||= "id"
    direction ||= "DESC"

    order("#{attribute} #{direction}")
  }
    # You can OVERRIDE this method used in model form and search form (in belongs_to relation)
  def caption
    (self["name"] || self["label"] || self["description"] || "##{id}")
  end
  belongs_to :model
  attr_accessible :model_id, :additional_details, :body_type, :color, :doors, :equipment, :equipment_fulltext, :equipment_typetext, :fuel, :mileage, :mileage_warranty, :notes, :notes_fulltext, :notes_typetext, :price, :registration, :registration_year
end
