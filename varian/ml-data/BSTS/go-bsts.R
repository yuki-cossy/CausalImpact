# read incremental plot series
source("./plot_incremental_fit.R")

 # set defaults
 numiter <- 4000
 npred <- 5
 ss <- AddLocalLinearTrend(list(),y)
 if(is.seasonal) {ss <- AddSeasonal(ss,y,nseasons=12)}
 model <- bsts(y~.,state.specification=ss,data=x,niter=numiter,ping=200,expected.model.size=npred,seed=123)

#report
pdf(paste(y.name,"-report.pdf",sep=""))
plot(model,main="Posterior distn of states")
plot(model,"forecast.distribution",main="One-step ahead forecast")
plot(model,"residuals",main="Residuals")
plot(model,"prediction.errors",main="Prediction error")
plot(model,"coef",inc=.10,cex.lab=1.2,cex.main=1.2,cex.names=1.2)
plot(model,"comp")
plot(model,"predictors",main="Predictors")
# plot(model,"size")
# plot(model,"dynamic")
graphics.off()

# incremental plots     
 b <- summary(model)$coef[1:7,1]
 temp <- model$state.contributions
 num <- dim(temp)[[3]]
 trend <- rep(NA,num)
 for (t in 1:num) trend[t] <- mean(temp[,1,t])
 z <- as.matrix(x[,names(b)])%*%diag(b)     

# need to add seasonal component if seasonal
if(is.seasonal) {
 seasonal <- rep(NA,num)
 for (t in 1:num) seasonal[t] <- mean(temp[,2,t])
 nplots <- npred+3
 df <- data.frame(y,trend,seasonal,z)
 names(df) <- c("y","trend","seasonal",names(b))
} else {
 nplots <- npred+2
 df <- data.frame(y,trend,z)
 names(df) <- c("y","trend",names(b))
}

# override to save space
npred=6
# print them out
plot.name <- paste(y.name,"-all.pdf",sep="")
pdf(plot.name)
PlotIncrementalFit(df,response.colname="y",component.colnames=names(df)[2:nplots],png.filename=plot.name)
graphics.off()

#print out small version of incremental plots
#PlotIncrementalFit(df,response.colname="y",component.colnames=names(df)[2:nplots],png.fname.series=y.name)

# PNG version
#PlotIncrementalFit(df,response.colname="y",component.colnames=names(df)[2:nplots],png.fname.series=y.name,plot.type="together",color.spec=kGrayscaleColorSpec)

# PDF B&W
#PlotIncrementalFit(df,response.colname="y",component.colnames=names(df)[2:nplots],plot.fname.series=y.name,plot.type="together",color.spec=kGrayscaleColorSpec,plot.ftype="pdf")

#PlotIncrementalFit(df,response.colname="y",component.colnames=names(df)[2:nplots],plot.fname.series=y.name,plot.type="together",plot.ftype="pdf")

PlotIncrementalFit(df,response.colname="y",component.colnames=names(df)[2:nplots],plot.fname.series=y.name,plot.type="together",plot.ftype="pdf")

