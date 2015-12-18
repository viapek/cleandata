
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
    library(data.table)
    
    ####################################################################
    # open the features file and extract the column and activity names #
    ####################################################################
    
    # get the column names from features.txt
    columnNames <- read.delim('features.txt', sep = "\t", header = FALSE, stringsAsFactors = FALSE)
    
    # add subject and activity titles
    columnNames <- c('Subject','Activity', unlist(columnNames, recursive = FALSE))
    
    # get the activity labels
    labKey <- data.table(read.table('./activity_labels.txt'))
    
    ###########################
    # Get the test data first #
    ###########################
    
    # get the labels from the test set
    labTest <- data.table(read.table('./test/y_test.txt'))
    
    # make a header set with descriptive labels
    labTest$label <- labKey$V2[match(labTest$V1,labKey$V1)]
    
    # get the subject identifier
    subjectTest <- read.table('./test/subject_test.txt')
    
    # get the data
    datTest <- data.table(read.table('./test/X_test.txt'))
    
    # combine the labels with the data
    testData <- cbind(subjectTest,labTest$label,datTest)
    
    # applying the column names
    names(testData) <- columnNames
    
    # clear variables to save memory
    rm(list=ls()[grep('Test',ls())])
    
    #############################
    # Get the train data second #
    #############################
    
    # get the labels from the train set
    labTrain <- data.table(read.table('./train/y_train.txt'))
    
    # make a header set with descriptive labels
    labTrain$label <- labKey$V2[match(labTrain$V1,labKey$V1)]
    
    # get the subject identifier
    subjectTrain <- read.table('./train/subject_train.txt')
    
    # get the data
    datTrain <- data.table(read.table('./train/X_train.txt'))
    
    # combine the labels with the data
    trainData <- cbind(subjectTrain,labTrain$label,datTrain)
    
    # apply the column names
    names(trainData) <- columnNames
    
    # clear variables to save memory
    rm(list=ls()[grep('Train',ls())])
    
    
    #####################################################################
    # put the two datasets together and make sure it's in a nice format #
    #####################################################################
    
    # combine the two sets
    completeData <- rbind(testData,trainData)
    
    # make sure it is a data.table
    completeData <- as.data.table(completeData)
    
    # drop the columns not related to mean or std
    completeData <- select(completeData, 1, 2, grep('mean', names(completeData)),grep('std', names(completeData)))
    
    #############################################
    # Make the headings readable and meaningful #
    #############################################
    
    # get the column name
    columnNames <- names(completeData)
    
    # clean up the column names and reassign using regex and a diminishing scope
    columnNames <- gsub('[0-9]*\\s[a-z]([^-]*)\\S*(mean|std)\\S*-([XYZ]?)', '\\1 \\2 \\3', columnNames)
    columnNames <- gsub('[0-9]*\\s[a-z]([^-]*)\\S*(mean|std)\\S*', '\\1 \\2', columnNames)
    
    # put the new column names back into the names space
    names(completeData) <- columnNames
    
    
    ###########
    # tidy up #
    ###########
    
    # clear the all but the completeData set to save memory
    rm(list=ls()[-match('completeData',ls())])
    
    
    #############################
    # make the averaged Dataset #
    #############################
    averageData <- completeData[,lapply(.SD, mean),by=c('Subject','Activity')]
    
    
  } else {
    print('completeData already formed')
    print('If you wish to refresh please rm(\'completeData\') and try again.')
  }
}
