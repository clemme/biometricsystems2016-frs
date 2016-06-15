source("/usr/local/share/openbr/plotting/plot_utils.R")

# Read CSVs
data <- NULL
tmp <- read.csv("FaceRecognition_MEDS.csv")
tmp$File <- "FaceRecognition_MEDS"
data <- rbind(data, tmp)

confidence <- 0.95
ncol <- 1
basename <- "./MEDS"
smooth <- FALSE
csv <- FALSE
majorHeader <- "File"
majorSize <- 1
majorSmooth <- FALSE
minorHeader <- ""
minorSize <- 0
minorSmooth <- FALSE
flip <- FALSE

# Open output device
pdf("./MEDS.pdf")

# Write figures

formatData()

algs <- TF$File
algs <- algs[!duplicated(algs)]

# Write metadata table
plotMetadata(metadata=Metadata, title="OpenBR - 1.1.0")
plot.new()
plotTable(tableData=TF, name="Table of True Accept Rates at various False Accept Rates", labels=c("FAR = 1e-06", "FAR = 1e-05", "FAR = 1e-04", "FAR = 1e-03", "FAR = 1e-02", "FAR = 1e-01"))
plotTable(tableData=FT, name="Table  of False Accept Rates at various True Accept Rates", labels=c("TAR = 0.40", "TAR = 0.50", "TAR = 0.65", "TAR = 0.75", "TAR = 0.85", "TAR = 0.95"))
plotTable(tableData=CT, name="Table of retrieval rate at various ranks", labels=c("Rank 1", "Rank 5", "Rank 10", "Rank 20", "Rank 50", "Rank 100"))
plotTable(tableData=TS, name="Template Size by Algorithm", labels=c("Template Size (bytes):"))

plot <- plotLine(lineData=DET, options=list(xLog=TRUE,xTitle="False Accept Rate",yLog=FALSE,yTitle="True Accept Rate"), flipY=TRUE)
plot
plot <- plotLine(lineData=DET, options=list(xLog=TRUE,xTitle="False Accept Rate",yLog=TRUE,yTitle="False Reject Rate"), flipY=FALSE)
plot
plot <- plotLine(lineData=IET, options=list(xLog=TRUE,xTitle="False Positive Identification Rate (FPIR)",yLog=TRUE,yTitle="False Negative Identification Rate (FNIR)"), flipY=FALSE)
plot
plot <- plotLine(lineData=CMC, options=list(size="1",xBreaks="c(1,5,10,50,100)",xLabels="c(1,5,10,50,100)",xLog=TRUE,xTitle="Rank",yLog=FALSE,yTitle="Retrieval Rate"), flipY=FALSE)
plot
plot <- plotSD(sdData=SD)
plot
plot <- plotBC(bcData=BC)
plot
plot <- plotERR(errData=ERR)
plot
plotEERSamples(imData=IM, gmData=GM)

dev.off()
