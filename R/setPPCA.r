#' Low level methods to set pPCA class content
#'
#' Low level methods to set pPCA class content - not to be invoked directly
#' @param model of class "pPCA"
#' @param value set the specific value
#' @return returns an updated pPCA object
#' @name Set-pPCA-class
#' @rdname ppcasetters
#' @docType methods
#' @keywords internals
NULL

#' @rdname ppcasetters
#' @export
setGeneric("SetNoiseVariance<-", function(x, value) standardGeneric("SetNoiseVariance<-"))
#' @name Set-pPCA-class
#' @rdname ppcasetters
setReplaceMethod("SetNoiseVariance", "pPCA",function(x, value) {x@sigma <- value; validObject(x); x})


#' @rdname ppcasetters
#' @export
setGeneric("SetRawdata<-", function(x, value) standardGeneric("SetRawdata<-"))
#' @name Set-pPCA-class
#' @rdname ppcasetters
setReplaceMethod("SetRawdata", "pPCA",function(x, value) {x@rawdata <- value; validObject(x); x})

#' @rdname ppcasetters
#' @export
setGeneric("SetPCBasisMatrix<-", function(x, value) standardGeneric("SetPCBasisMatrix<-"))
#' @name Set-pPCA-class
#' @rdname ppcasetters
setReplaceMethod("SetPCBasisMatrix", "pPCA",function(x, value) {x@PCA$rotation <- value; validObject(x); x})

#' @rdname ppcasetters
#' @export
setGeneric("SetPCsdev<-", function(x, value) standardGeneric("SetPCsdev<-"))
#' @name Set-pPCA-class
#' @rdname ppcasetters
setReplaceMethod("SetPCsdev", "pPCA",function(x, value) {x@PCA$sdev <- value; validObject(x); x})

#' @rdname ppcasetters
#' @export
setGeneric("SetMeanVector<-", function(x, value) standardGeneric("SetMeanVector<-"))
#' @name Set-pPCA-class
#' @rdname ppcasetters
setReplaceMethod("SetMeanVector", "pPCA",function(x, value) {x@PCA$center <- value; validObject(x); x})

#' @rdname ppcasetters
#' @export
setGeneric("SetScores<-", function(x, value) standardGeneric("SetScores<-"))
#' @name Set-pPCA-class
#' @rdname ppcasetters
setReplaceMethod("SetScores", "pPCA",function(x, value) {x@PCA$x <- value; validObject(x); x})

#' @rdname ppcasetters
#' @export
setGeneric("SetScale<-", function(x, value) standardGeneric("SetScale<-"))
#' @name Set-pPCA-class
#' @rdname ppcasetters
setReplaceMethod("SetScale", "pPCA",function(x, value) {
    x@scale <- value;
    chk <- pairNameCheck(x@modelinfo@paraminfo,"scale")
    if (!chk) {
        x <- AddModelInfoParams(x,c("scale",tolower(as.character(value))))
    } else {
        x@modelinfo@paraminfo <- x@modelinfo@paraminfo[-chk]
        x <- AddModelInfoParams(x,c("scale",tolower(as.character(value))))
    }
        
    validObject(x); x})

#' @rdname ppcasetters
#' @export
setGeneric("SetPCA<-", function(x, value) standardGeneric("SetPCA<-"))
#' @name Set-pPCA-class
#' @rdname ppcasetters
setReplaceMethod("SetPCA", "pPCA",function(x, value) {x@PCA <- value; validObject(x); x})

#' @rdname ppcasetters
#' @export
setGeneric("SetVariance<-", function(x, value) standardGeneric("SetVariance<-"))
#' @name Set-pPCA-class
#' @rdname ppcasetters
setReplaceMethod("SetVariance", "pPCA",function(x, value) {x@Variance <- value; validObject(x); x})

#' @rdname modelinfo-class
#' @export
setGeneric("AddModelInfoParams", function(x, value) standardGeneric("AddModelInfoParams"))
#' @rdname modelinfo-class
setMethod("AddModelInfoParams", signature("modelinfo"),function(x, value) {
    if (!is.list(value))
        value <- list(value)
    x@paraminfo <-append(x@paraminfo,value); validObject(x);
    return(x)
})

#' @rdname ppcasetters
setMethod("AddModelInfoParams", signature("pPCA"),function(x, value) {
    x@modelinfo <- AddModelInfoParams(x@modelinfo,value);validObject(x)
    return(x)
    
})
#' @rdname modelinfo-class
#' @export
setGeneric("SetModelInfoParams<-", function(x, value) standardGeneric("SetModelInfoParams<-"))
#' @rdname modelinfo-class
#' @name modelinfo-class
setReplaceMethod("SetModelInfoParams", signature("modelinfo"),function(x, value) {
    x@paraminfo <-value; validObject(x); x
})

pairNameCheck <- function(x,value) {
    full <- unlist(x)
    full <- full[ (1:length(full)) %% 2 != 0]
    chk <- duplicated(c(value,full))
    if (sum(chk > 0))
        return(which(chk)-1)
    else
        return(FALSE)
}
    
