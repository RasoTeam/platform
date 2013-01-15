# == Schema Information
#
# Table name: course_signups
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  course_id  :integer
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CourseSignup < ActiveRecord::Base
  attr_accessible :course_id, :status, :user_id
  belongs_to :course
  belongs_to :user

end
