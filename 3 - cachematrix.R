## Matrix inversion is usually a costly computation and there may be 
## some benefit to caching the inverse of a matrix rather than computing 
## it repeatedly. The following pair of functions computes the inverse
## of a matrix and stores it in cache for future retrieval.


## This function creates a special "matrix" object: a list that comprises
## functions to set the value of the matrix (set), retrieve its value (get), 
## set its inverse (setInverse), and retrieve its inverse (getInverse.)

makeCacheMatrix <- function(x = matrix()) {
    i <- NULL
    set <- function(y) {
        x <<- y
        i <<- NULL
    }
    get <- function() x
    setInverse <- function(inverse) i <<- inverse
    getInverse <- function() i
    list(set = set, get = get,
         setInverse = setInverse,
         getInverse = getInverse)
}


## This function computes and returns the inverse of the special "matrix" 
## created by makeCacheMatrix. It first checks to see if an inverse matrix 
## had already been computed, and if so returns the inverse matrix from 
## cache. Otherwise, it performs the computation, stores its value in
## cache and returns the inverse matrix.

cacheSolve <- function(x, ...) {
    m <- x$getInverse()
    if(!is.null(m)) {
        message("getting cached data")
        return(m)
    }
    data <- x$get()
    m <- solve(data, ...)
    x$setInverse(m)
    m
}
