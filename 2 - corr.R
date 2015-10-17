corr <- function(directory, threshold = 0) {
    
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'threshold' is a numeric vector of length 1 indicating the
    ## number of completely observed observations (on all
    ## variables) required to compute the correlation between
    ## nitrate and sulfate; the default is 0
    
    ## Return a numeric vector of correlations
    ## NOTE: Do not round the result!

    # List and prepend files
    files <- list.files(directory, full.names = TRUE)
    
    # Define function to read files
    read_file <- function(x) {
        read.csv(files[x])
    }

    # Define variable as data frame from complete.R
    df <- complete(directory)
    
    # Create vector of IDs from subset where observations exceed threshold
    threshold_df <- subset(df, nobs > threshold)
    threshold_id <- threshold_df$id
        
    # Loop data in range to create vector with correlations
    correlation <- numeric()
    for(i in threshold_id) {
        file_unomitted <- read_file(i)
        file <- na.omit(file_unomitted)
        correlation <- c(correlation, cor(file$sulfate, file$nitrate))
    }
    
    # Return correlation vector
    return(correlation)
    
}
