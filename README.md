# cleaning-data
# Coursera project
->This is my submission to the Coursera project of Getting and Cleaning Data<-

There is only one R script and it is very straightforward Extract, Transform and Load (an ETL classic process).

The files to load are text files delimited by “”, no blanks, (I have some problems to discover that.

After loading the data in main memory, I used rbind for the union of x_files and y_files for the training and test. In the same way I to union subject_test and subject_train

For the features, we need to select only mean and standard deviation aspects, so I use regular expression for do that. In the same way for erase parentheses and other no alphanumeric symbols I used grep. Finally I change – symbol to _ symbol using gsub, one more time with the help of regular expressions.

For the activity labels I use merge in order to create a new column in the final file 

In order to obtain the mean of the columns, I used the aggraget.dat.frame in  order to group first for subject and activity name, and then apply mean to the result and obtain the file required.

