source("setup.R")
Sys.setlocale("LC_TIME", "Spanish")

# Piezometer Data
PID <- readxl::read_xlsx("data/data.xlsx",sheet="PID") |> as.data.table()
# PID[,LOC:=NULL]

# TSF Data ----
DT <- readxl::read_xlsx("data/data.xlsx",sheet="TSF") 
NC <- ncol(DT)
DT <- readxl::read_xlsx("data/data.xlsx",sheet="TSF",na="sin medicion",col_types = c("date",rep("text",NC-1))) |> as.data.table()


DT[,DATE:=as.Date(DATE)]
DT <- DT[!is.na(DATE)]
setcolorder(DT,neworder = "DATE")
# DT[,n:=.I]
DT[,SID:="TSF"]

MVARS <- grep(colnames(DT),pattern = "-",value = TRUE)
# IVARS <- c("n","DATE","SID")
IVARS <- c("DATE","SID")
DT.TSF <- melt(DT,id.vars = IVARS,measure.vars = MVARS)
setnames(DT.TSF,old = c("variable","value"),new=c("ID","D"))

# POND Data  ----
DT <- readxl::read_xlsx("data/data.xlsx",sheet="POND") 
NC <- ncol(DT)
DT <- readxl::read_xlsx("data/data.xlsx",sheet="POND",na="sin medicion",col_types = c("date",rep("text",NC-1))) |> as.data.table()
DT[,DATE:=as.Date(DATE)]
DT <- DT[!is.na(DATE)]
setcolorder(DT,neworder = "DATE")
# DT[,n:=.I]
DT[,SID:="POND"]

MVARS <- grep(colnames(DT),pattern = "-",value = TRUE)
# IVARS <- c("n","DATE","SID")
IVARS <- c("DATE","SID")
DT.POND <- melt(DT,id.vars = IVARS,measure.vars = MVARS)
setnames(DT.POND,old = c("variable","value"),new=c("ID","D"))

# Bind TSF + POND ----
DT <- rbindlist(list(DT.POND,DT.TSF))
rm(DT.POND,DT.TSF)

# Merge PID data
DT <- PID[DT, on=c("ID","SID")]

# Water Depth
DT[D=="seco",`:=`(WD=L,OBS=D)] # Water Depth
DT[D!="seco",`:=`(WD=as.numeric(D),OBS="agua")]
# Water Level
DT[,WL:=L-WD]

# Get m.s.n.m values
DT[,CD:=C-WD]


# Remove N/A Values
DT <- na.omit(DT)

# Get DIFF from WLsl
DT <- DT[,.(DATE=DATE[seq(2,.N)],LOC=LOC[seq(2,.N)],WL=WL[seq(2,.N)]|> round(digits = 1),CD=CD[seq(2,.N)]|> round(digits = 1),DIFF=(CD[seq(2,.N)]-CD[seq(1,.N-1)])|> round(digits = 2),OBS=OBS[seq(2,.N)]),by=c("ID","SID")]
DT[1,DIFF:=0,by=c("ID","SID")]
DT[,RDATE:=format(DATE,format="%Y-%m")]
# DT <- fread("data/wideData.csv",na.strings = c("sin medicion",""),header = TRUE,blank.lines.skip = TRUE)
fwrite(DT,file="data/longData.csv",yaml = TRUE)
rm(list=ls())
