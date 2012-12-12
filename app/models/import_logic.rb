class ImportLogic < ActiveRecord::Base
  # attr_accessible :title, :body


#
# Returns the sheets on the target Excel File
#
	def get_sheets_from_excel_file(fullPath)

		#Spreadsheet.client_enconding = 'UTF-8'
		book = Spreadsheet.open fullPath
		sheetsNum = book.worksheets.count

		sheets_array = []
		#Iterate trough the excel worksheets
		$i=0
		while $i<sheetsNum

			#Get the Sheet
			sheet = book.worksheet $i
			sheets_array[$i] = sheet.name

		$i += 1
		end

	return sheets_array
	end



#
# Returns the Data from the target Excel File
#
	def read_default_data_from_sheet(fullPath, sheet_name)

		book = Spreadsheet.open fullPath
		sheet = book.worksheet sheet_name

		#Getting the sheet dimensions
		dim = sheet.dimensions
		fst_row = dim[0]
		lst_row = dim[1]
		fst_col = dim[2]
		lst_col = dim[3]

		line_data = Array.new
		sheet_data = Array.new(line_data)

		$row_count = 0
		$k = fst_row
		while $k<lst_row

				line_data = Array.new
				$column_count = 0
				$z = fst_col
				while $z<lst_col
				
					#storing the data
					line_data[$column_count] = sheet.cell($k,$z).to_s

				$column_count += 1
				$z += 1
				end

				sheet_data[$row_count] = line_data

		$row_count += 1
		$k += 1
		end

	return sheet_data	
	end



end
