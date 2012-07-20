# wiked_pdf.rb

WickedPdf.config = {
   :exe_path => `which wkhtmltopdf`.gsub(/\n/, '') #if wkhtmltopdf is installed at this path
}
