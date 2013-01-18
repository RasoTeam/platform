# == Company Model
#  Contains information about a company
#
# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  logo_url   :string(255)
#  address    :string(255)
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
# 
class Company < ActiveRecord::Base 
  extend FriendlyId
  friendly_id :slug

  attr_accessible :address, :logo_url, :name, :state, :slug, :attach
  has_many :bills
  has_many :users
  has_many :time_offs
  has_many :trainings
  has_many :job_offers
  has_many :evaluations

  has_attached_file :attach, :default_url => "http://placehold.it/250x250"


  before_save { |company| company.slug = slug.downcase
              }

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :state, :presence => true
  VALID_slug_REGEX = /\A[a-z\d][a-z\d_-]*\z/i
  validates :slug, :presence => true, 
            :length => { :maximum => 100, :minimum => 3 },
            :format => { :with => VALID_slug_REGEX }, :uniqueness => { :case_sensitive => false }
  validates :address, :length => { :maximum => 100 }

  validates_attachment_size :attach, :less_than => 1.megabyte, #another option is :greater_than
    :message => "max size is 1M"

  validates_attachment_content_type :attach,
    :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png'],
    :message => "only image files are allowed"

  #scope :cenas, lambda { self.bills.order("created_at Desc").paginate(:page => params[:page], :per_page => 4) }
  #scope :users_paginate, lambda { self.users.paginate(:page => params[:page], :per_page => 4) }

  # Searches for companies which match certan properties
  #
  # @param [String] search is used to filter companies with id LIKE or with slug LIKE
  # @param [String] order is used to order the result as "ASC" or "DESC". default "ASC".
  # @param [String] state companies by state. 
  #  Examples:
  #  ">= 0"
  #  "< 0"
  #  "==0"
  #  default: nil.
  # @return [Relation] All companies matching the parameters.
  def self.search(search,order,state=nil)
    order ||= ""
    if search
      companies = where('name LIKE ? OR slug LIKE ?', '%'+search+'%', '%'+search+'%').order("slug "+order)
    else
      companies = order("slug "+order)
    end
    if !state.blank?
      companies = companies.where('state = ?', Integer(state))
    end
    return companies
  end

end
