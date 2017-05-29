## Resubmission
I submitted an update of this package several days ago, primarily to deal with a problem it was causing for the quanteda package (from which this package imports example data). While I thought I had removed all references to a defunct dataset, I missed one in a test. I have removed it and changed quanteda to a suggested instead of an imported package to deal with the CRAN NOTE. I sincerely appologize for the quick resubmission but I would greatly appreciate if you would be willing to put this version up on CRAN. The quanteda developers cannot make an important update to thier package until this version is fixed. Thank you!

## Test environments
* local OS X (10.11.6) install, R 3.4.0
* win-builder (devel and release)
* CentOS 6.8, R 3.4.0

## R CMD check results
There were no ERRORs or WARNINGs on Windows, OS X, or Linux. There was a single NOTE regarding the spelling of "un-processed" in our DESCRIPTION file, but we believe it is correctly spelled. 

## Downstream dependencies
The package does not have any downstream dependencies as it is a new package. 


