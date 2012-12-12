class CourseSignup < ActiveRecord::Base
  attr_accessible :course_id, :status, :user_id
  belongs_to :course
  belongs_to :user

end
