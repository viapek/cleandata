
#########################################################
# check we are in the right directory, or at least that #
#         it looks like the right directory             #
#########################################################

# check for train and test in the current directory
if (!'./train' %in% list.dirs()) {
    for (i in 1:70) {
      cat("*")
    }
    cat('\n* ')
    cat("You do not appear to be in the correct directory.")
    cat('\n*\n* ')
    cat("We expect to find a 'train' directory for this script to work.")
    cat('\n*\n* ')
    cat("Change directories and then run me again.")
    cat('\n')
    for (i in 1:70) {
      cat("*")
    }    
} else {

  
  # check to see if the completeData set alread exists
  if (is.null(get0('completeData', envir = globalenv()))) {
    
    ###############################
    # load the data table library #
    ###############################
    cat('Loading libraries')
    oldw <- getOption("warn")
    options(warn = -1)
    
    require(data.table)
    cat('.')
    require(dplyr)
    cat('.\n')
    options(warn = oldw)
    
    
    ####################################################################
    # open the features file and extract the column and activity names #
    ####################################################################
    cat('Getting column names')
    # get the column names from features.txt
    columnNames <- read.delim('features.txt', sep = "\t", header = FALSE, stringsAsFactors = FALSE)
    cat('.')
    # add subject and activity titles
    columnNames <- c('Subject','Activity', unlist(columnNames, recursive = FALSE))
    cat('.')
    # get the activity labels
    labKey <- data.table(read.table('./activity_labels.txt'))
    cat('and activity labels.\n')
    
    ###########################
    # Get the test data first #
    ###########################
    
    cat('Reading from test dataset')
    # get the labels from the test set
    labTest <- data.table(read.table('./test/y_test.txt'))
    cat('.')
    # make a header set with descriptive labels
    labTest$label <- labKey$V2[match(labTest$V1,labKey$V1)]
    cat('.')
    # get the subject identifier
    subjectTest <- read.table('./test/subject_test.txt')
    cat('.')
    # get the data
    datTest <- data.table(read.table('./test/X_test.txt'))
    cat('.')
    # combine the labels with the data
    testData <- cbind(subjectTest,labTest$label,datTest)
    cat('.')
    # applying the column names
    names(testData) <- columnNames
    cat('.')
    # clear variables to save memory
    rm(list=ls()[grep('Test',ls())])
    cat('.\n')
    
    #############################
    # Get the train data second #
    #############################
    
    cat('Reading from training dataset')
    # get the labels from the train set
    labTrain <- data.table(read.table('./train/y_train.txt'))
    cat('.')
    # make a header set with descriptive labels
    labTrain$label <- labKey$V2[match(labTrain$V1,labKey$V1)]
    cat('.')
    # get the subject identifier
    subjectTrain <- read.table('./train/subject_train.txt')
    cat('.')
    # get the data
    datTrain <- data.table(read.table('./train/X_train.txt'))
    cat('.')
    # combine the labels with the data
    trainData <- cbind(subjectTrain,labTrain$label,datTrain)
    cat('.')
    # apply the column names
    names(trainData) <- columnNames
    cat('.\n')
    # clear variables to save memory
    rm(list=ls()[grep('Train',ls())])
    
    
    #####################################################################
    # put the two datasets together and make sure it's in a nice format #
    #####################################################################
    cat('Combining datasets')
    # combine the two sets
    completeData <- rbind(testData,trainData)
    cat('.')
    # make sure it is a data.table
    completeData <- as.data.table(completeData)
    cat('.')
    # drop the columns not related to mean or std
    completeData <- select(completeData, 1, 2, grep('mean()', names(completeData)),grep('std()', names(completeData)))
    cat('.\n')
    
    #############################################
    # Make the headings readable and meaningful #
    #############################################
    cat('Tidying dataset and columns')
    # get the column name
    columnNames <- names(completeData)
    cat('.')
    # clean up the column names and reassign using regex and a diminishing scope
    columnNames <- gsub('[0-9]*\\s[a-z]([^-]*)\\S*(mean|std)\\S*-([XYZ]?)', '\\1 \\2 \\3', columnNames)
    columnNames <- gsub('[0-9]*\\s[a-z]([^-]*)\\S*(mean|std)\\S*', '\\1 \\2', columnNames)
    cat('.')
    # put the new column names back into the names space
    names(completeData) <- columnNames
    cat('.\n')
    
    ###########
    # tidy up #
    ###########
    
    # clear the all but the completeData set to save memory
    rm(list=ls()[-match('completeData',ls())])
    
    
    #############################
    # make the averaged Dataset #
    #############################
    averageData <- completeData[,lapply(.SD, mean),by=c('Subject','Activity')]
    
    cat('Script complete. completeData is the name of the dataset.\n')
    
  } else {
    print('completeData already formed')
    print('If you wish to refresh please rm(\'completeData\') and try again.')
  }
}
