module Commons::ValidateCommon
    def check_file_type_excel(file)
    return if detect_file_type_excel(file)

    error = ''
    error << 'Please choose xlsx file.'
    raise StandardError, error
  end

  def detect_file_type_excel(file_object)
    ['.xlsx', '.xls'].include?(File.extname(file_object.original_filename))
  end
end
