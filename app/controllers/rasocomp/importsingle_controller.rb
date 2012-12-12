class Rasocomp::ImportsingleController < Rasocomp::ApplicationController

	#The model to be imported
	def fst_step

		session[:error] = "none"
		session[:companyid] = params[:companyid]
		session[:model] = params[:model]
		session[:model_name] = params[:model].split('/')[(params[:model].split('/').count)-1]
		render :_fst_step

	end




	#The excel file to be imported
	def snd_step

		if(!params[:excel_file].nil?)
			session[:error] = "none"

			filename = params[:excel_file].original_filename
			directory = "public/_temp_excel_files"
		

			if !(filename.split('.')[(filename.split('.').count)-1].eql?("xls")) || !(filename.split('.')[(filename.split('.').count)-1].eql?("xlsx"))
				session[:error] = "File not valid"
				render :_fst_step
			else
				session[:error] = "none"

				session[:excel_file] = (Time.now.to_i).to_s+""+filename

				#create the path
				session[:excel_file_path] = File.join(directory, session[:excel_file])
				#store the file
				File.open(session[:excel_file_path], "wb") { |f| f.write(params[:excel_file].read) }

				#get the worksheet names as an array of strings
				@import_logic = ImportLogic.new
				sheets_array = @import_logic.get_sheets_from_excel_file(session[:excel_file_path])
				session[:sheetsArray] = sheets_array

				render :_snd_step
			end

		else
			session[:error] = "Choose a file"
			render :_fst_step
		end

	end




	#The excel sheet from where to be imported
	def trd_step

		if params[:sheet].nil?
			session[:error] = "No sheet was selected"
			render :_snd_step
		else
			session[:error] = "none"

			session[:excel_sheet] = params[:sheet]
			render :_trd_step
		end

	end




	#The Default Confirmation import mode
	def default_confirmation_step

		if params[:import_mode].nil?
			session[:error] = "No import mode was choosen"
			render :_trd_step
		else
			session[:error] = "none"
			session[:import_mode] = params[:import_mode]

			if params[:import_mode].eql?("default")
				session[:error] = "none"

				#Read the Data from the Excel Sheet
				@import_logic = ImportLogic.new
				session[:sheet_data] = @import_logic.read_default_data_from_sheet(session[:excel_file_path], session[:excel_sheet])

				render :_default_confirmation_step
			else
				if params[:import_mode].eql?("custom")
					session[:error] = "The custom method is not yet implemented"
					render :_trd_step
					#render :_custom_step
				else
					session[:error] = "none"
					render :_trd_step
				end
			end
		end

	end




	#The Custom import mode
	def custom_step
		render :text => "custom_import"
	end




	#The Final import mode
	def final_import_step

	#Pick the sheet entries and create the model entry for each
	#Check the model

			imported_users = Array.new

			isValid = validateExcel
			if isValid == 1
				session[:error] = "none"

				$i1 = 1
				$j1 = 0
				while $i1 < session[:sheet_data].count

					line_data = session[:sheet_data][$i1]

					name = (line_data[0]).to_s
					email = (line_data[1]).to_s
					role = (line_data[2]).to_s

					#Create the User
					company = Company.find(session[:companyid])
					us = company.users.build
					us.name = name 
					us.email = email
					us.role = role.to_i
					us.state = -1
    				us.password_digest = 0
    				if us.save
      					UserMailer.verification_email(us).deliver

      					period = us.periods.build
      					period.start_date = Date.today
      					period.state = STATE[:unchecked]
      					period.save

      					imported_users[$j1] = name
      					$j1 += 1
      				end
					#Company.create(:name => name, :created => created, :nif => nif)

				$i1 += 1
				end

			session[:imported_users] = imported_users
			render :_final_import_step

			else
				render :_datanotvalid
			end

	end




	#Return to the current model index page and dump all session variables
	def finalize

		#delete the temp file
		File.delete(session[:excel_file_path])

		session.delete(:imported_users)
		session.delete(:import_mode)
		session.delete(:excel_sheet)
		session.delete(:excel_file_path)
		session.delete(:excel_file)

		temp_model= session[:model]
		session.delete(:model)
		session.delete(:companyid)

		#delete the temp file

		redirect_to temp_model.to_s
	end


	#Return to the sheet options
	def import_another

		session.delete(:imported_users)
		session.delete(:sheet_data)
		session.delete(:import_mode)
		session.delete(:excel_sheet)

		render :_snd_step
	end


	#Validates the excel
	def validateExcel

		result=1
		#It's different between models

		#
		#User model
		#
		#check the number of lines
		if session[:sheet_data].count >0
			#check the number of columns
			if (session[:sheet_data][0]).count == 3

				nameFlag=0
				emailFlag=0
				roleFlag=0

				#check the columns indexes
				(session[:sheet_data][0]).each do |colIndex|

					#search for the Name idex
					if (colIndex.to_s).eql?("Name")
						nameFlag=1
					end
					#search for the Email index
					if (colIndex.to_s).eql?("Email")
						emailFlag=1
					end
					#search for the Role index
					if (colIndex.to_s).eql?("Role")
						roleFlag=1
					end

				end

				#Validate all columns indexes
				if nameFlag==1 && emailFlag==1 && roleFlag==1
				else
					result = 0
				end
			else
				result=0
			end
		else
			result=0
		end

	return result
	end

end
