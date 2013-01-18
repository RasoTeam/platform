# == Export Model
#  Used to export users to xls format
class ExportLogic < ActiveRecord::Base
  # attr_accessible :title, :body

#
# Exports to excel the company users
#
	def export_users_from_company(company_id, company_name, emailsArray)

		book = Spreadsheet::Workbook.new
		sheet1 = book.create_worksheet
		sheet1.name = company_name.to_s + "_users" 

		sheet1[0,0]='Name'
		sheet1[0,1]='Email'
		sheet1[0,2]='Role'

		$row=1
		$array_it=0

		emailsArray.each do |user_email|

			@user = User.find_by_company_id_and_email(company_id, emailsArray[$array_it])
			sheet1[$row,0]= @user.name.to_s
			sheet1[$row,1]= @user.email.to_s
			sheet1[$row,2]= @user.role.to_s

			$row += 1
			$array_it += 1
		end

		bookname = company_name.to_s + '_' + (Time.now.to_i).to_s + '_users.xls'
		bookpath = 'public/_temp_down_excel_files/' + bookname
		book.write bookpath
		
		return bookpath

	end


	#
# Exports to excel the company users time_offs
#
	def export_timeoffs_from_company(company_id, company_name, emailsArray)

		book = Spreadsheet::Workbook.new
		sheet1 = book.create_worksheet
		sheet1.name = company_name.to_s + "_timeoffs" 

		sheet1[0,0]='Titulo'
		sheet1[0,1]='Tipo'
		sheet1[0,2]='Data de Inicio'
		sheet1[0,3]='Data de Fim'
		sheet1[0,4]='Email'

		$row=1
		$array_it=0

		emailsArray.each do |user_email|

			@user = User.find_by_company_id_and_email(company_id, emailsArray[$array_it])
			@timeoff = TimeOff.find_by_user_id(@user.id)
			if !(@timeoff.nil?)
				sheet1[$row,0]= @timeoff.description.to_s
				sheet1[$row,1]= @timeoff.category.to_s
				sheet1[$row,2]= @timeoff.start_at.to_s
				sheet1[$row,3]= @timeoff.end_at.to_s
				sheet1[$row,4]= @user.email.to_s

				$row += 1
				$array_it += 1
			end
		end

		bookname = company_name.to_s + '_' + (Time.now.to_i).to_s + '_timeoffs.xls'
		bookpath = 'public/_temp_down_excel_files/' + bookname
		book.write bookpath
		
		return bookpath

	end

end
