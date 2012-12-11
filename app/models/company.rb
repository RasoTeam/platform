

class Company < ActiveRecord::Base 
  extend FriendlyId
  friendly_id :slug

  attr_accessible :address, :logo_url, :name, :nif, :state, :slug
  has_many :bills
  has_many :users
  has_many :time_offs
  has_many :trainings
  has_many :job_offers


  before_save { |company| company.slug = slug.downcase
              }

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :state, :presence => true
  VALID_slug_REGEX = /\A[a-z\d][a-z\d_-]*\z/i
  validates :slug, :presence => true, 
            :length => { :maximum => 20, :minimum => 3 },
            :format => { :with => VALID_slug_REGEX }, :uniqueness => { :case_sensitive => false }

  #scope :cenas, lambda { self.bills.order("created_at Desc").paginate(:page => params[:page], :per_page => 4) }
  #scope :users_paginate, lambda { self.users.paginate(:page => params[:page], :per_page => 4) }

  def self.search(search,order)
    order ||= ""
    if search
      where('name LIKE ? OR slug LIKE ?', '%'+search+'%', '%'+search+'%').order("slug "+order)
    else
      order("slug "+order)
    end
  end

end
