# There is no global processing here.  This script only exists to avoid a warnings on runApp()
# Note: the specification for S3 class “AsIs” in package ‘jsonlite’ seems equivalent to one from 
# package ‘RJSONIO’: not turning on duplicate class definitions for this class.
# Note: See http://stackoverflow.com/questions/17181212/r-package-with-dependency-on-shiny-gives-rjsonio-warning
library(shiny)
