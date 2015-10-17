complete <- function(directory, id = 1:332) {

    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'id' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return a data frame of the form:
    ## id nobs
    ## 1  117
    ## 2  1041
    ## ...
    ## where 'id' is the monitor ID number and 'nobs' is the
    ## number of complete cases

    # List and prepend files
    files <- list.files(directory, full.names = TRUE)
    
    # Define function to read files
    read_file <- function(x) {
        read.csv(files[x])
    }
    
    # Define function to find and aggregate complete cases
    completed <- function(x) {
        find_complete <- complete.cases(read_file(x))
        agg_complete <- sum(find_complete)
        return(agg_complete)
    }
    
    # Loop data in range to create vector with aggregate observations
    nobs <- numeric()
    for(i in id) {
        nobs <- c(nobs, completed(i))
    }
    
    # Create and populate data frame with id and nobs columns
    data.frame(id, nobs)
    
}