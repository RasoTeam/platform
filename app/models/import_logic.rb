class ImportLogic < ActiveRecord::Base
  # attr_accessible :title, :body


#
# Returns the sheets on the target Excel File
#
	def get_sheets_from_excel_file(fullPath)

		require 'iconv'
		
		sheets_array = []

		case File.extname(fullPath)

			when ".ods"
	    		book = Openoffice.new(fullPath)      # creates an Openoffice Spreadsheet instance
			when ".xls"
			    book = Excel.new(fullPath)           # creates an Excel Spreadsheet instance
			when ".xlsx"
			    book = Excelx.new(fullPath)         # creates an Excel Spreadsheet instance for Excel .xlsx files
			else
				sheets_array[0] = File.extname(fullPath)
				return sheets_array
    	end

		sheetsNum = book.sheets.count
		#Iterate trough the excel worksheets
		$i=0
		while $i<sheetsNum

			sheets_array[$i] = book.sheets[$i]

		$i += 1
		end

	return sheets_array
	end



#
# Returns the Data from the target Excel File
#
	def read_default_data_from_sheet(fullPath, sheet_name)

		line_data = Array.new
		sheet_data = Array.new(line_data)

		case File.extname(fullPath)

			when ".xls"
			    book = Excel.new(fullPath)           # creates an Excel Spreadsheet instance
			when ".xlsx"
			    book = Excelx.new(fullPath)         # creates an Excel Spreadsheet instance for Excel .xlsx files
			else
				return sheet_data
				
    	end

		book.default_sheet = sheet_name

		#Getting the sheet dimensions
		fst_row = book.first_row
		lst_row = book.last_row
		fst_col = book.first_column
		lst_col = book.last_column


		$row_count = 0
		$k = fst_row
		while $k<=lst_row

				line_data = Array.new
				$column_count = 0
				$z = fst_col
				while $z<=lst_col
				
					#storing the data
					line_data[$column_count] = book.cell($k,$z).to_s

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
