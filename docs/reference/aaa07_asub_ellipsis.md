# Ellipses Usage in 'asub'

Due to how the S3 method dispatch system works in 'R', all generic
methods have the ellipsis argument (`...`).  
For the user's safety, 'asub' does check that the user doesn't
accidentally add arguments that make no sense for that method.  
  
  
