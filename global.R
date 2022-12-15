# params <- list( # DATE = as.Date("2022-04-01",format="%Y-%m-%d"),
#   PPT = "15.-Piezómetros Tranque Relaves Junio 2022")
DT <- fread(file="data/longData.csv",yaml = TRUE)
PID <- readxl::read_xlsx("data/data.xlsx",sheet="PID") |> as.data.table()
VALID_DATES <- unique(DT$DATE)
LAST_DATE <- max(DT$DATE)

