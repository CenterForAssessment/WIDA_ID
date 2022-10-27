##################################################################################
###
### Data preparation script for 2017 to 2022 WIDA-ACCESS ELPA Data
###
##################################################################################

### Load packages
require(data.table)
require(openxlsx)

### Load Data
WIDA_ID_Data_LONG <- as.data.table(read.xlsx("Data/Base_Files/Deidentified ELPA 2017-2022.xlsx", na.strings ="N/A"))

### Tidy up data
setnames(WIDA_ID_Data_LONG, c("YEAR", "SCHOOL_NUMBER", "ID", "CONTINUOUS_ENROLLMENT_STATUS", "GRADE", "GENDER", "ETHNICITY", "SES_STATUS", "SPECIAL_EDUCATION_STATUS", "LEP_STATUS", "MIGRANT_STATUS", "HOMELESS_STATUS", "FOSTER_STATUS", "MILITARY_CONNECTED_STATUS", "CONTENT_AREA", "TEST_TYPE", "PARTICIPATION_STATUS", "PROFICIENCY_STATUS", "ACHIEVEMENT_LEVEL_ORIGINAL", "SCALE_SCORE", "MAKING_PROGRESS_TARGET", "IS_MAKING_PROGRESS"))

WIDA_ID_Data_LONG[,YEAR:=as.character(YEAR)]
WIDA_ID_Data_LONG[,ID:=as.character(ID)]
WIDA_ID_Data_LONG[,CONTENT_AREA:="READING"]
WIDA_ID_Data_LONG[TEST_TYPE=="REGULAR", ACHIEVEMENT_LEVEL_ORIGINAL:=as.character(round(as.numeric(ACHIEVEMENT_LEVEL_ORIGINAL), digits=1))]
WIDA_ID_Data_LONG[TEST_TYPE=="REGULAR", ACHIEVEMENT_LEVEL_ORIGINAL:=strhead(paste0(ACHIEVEMENT_LEVEL_ORIGINAL, ".0"), 3)]
WIDA_ID_Data_LONG[,ACHIEVEMENT_LEVEL := strhead(ACHIEVEMENT_LEVEL_ORIGINAL, 1)]
WIDA_ID_Data_LONG[ACHIEVEMENT_LEVEL_ORIGINAL %in% c("4.2", "4.3", "4.4", "4.5", "4.6", "4.7", "4.8", "4.9"), ACHIEVEMENT_LEVEL:="4.2"]
WIDA_ID_Data_LONG[!is.na(ACHIEVEMENT_LEVEL),ACHIEVEMENT_LEVEL := paste("WIDA Level", ACHIEVEMENT_LEVEL)]
WIDA_ID_Data_LONG[,ACHIEVEMENT_LEVEL:=strhead(ACHIEVEMENT_LEVEL_ORIGINAL, 1)]
WIDA_ID_Data_LONG[,ACHIEVEMENT_LEVEL:=paste("WIDA Level", ACHIEVEMENT_LEVEL)]

WIDA_ID_Data_LONG[GRADE %in% c("KG", "PK"), GRADE:="0"]

### Invalidate Certain Cases 
WIDA_ID_Data_LONG[, VALID_CASE:="VALID_CASE"]
WIDA_ID_Data_LONG[TEST_TYPE!="REGULAR", VALID_CASE:="INVALID_CASE"]
WIDA_ID_Data_LONG[PARTICIPATION_STATUS=="N", VALID_CASE:="INVALID_CASE"]
WIDA_ID_Data_LONG[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]

### Check for duplicates (no duplicates amongst VALID_CASEs 10/26/22)
#setkey(WIDA_ID_Data_LONG, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID, SCALE_SCORE)
#setkey(WIDA_ID_Data_LONG, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
#WIDA_ID_Data_LONG[which(duplicated(WIDA_ID_Data_LONG, by=key(WIDA_ID_Data_LONG)))-1, VALID_CASE := "INVALID_CASE"]
#setkey(WIDA_ID_Data_LONG, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)

### Reorder columns
setcolorder(WIDA_ID_Data_LONG, c(24, 15, 1, 5, 3, 20, 23, 19, 18, 4, 2, 6:14, 16, 17, 21, 22))

### Save Results as separate files based upon years
WIDA_ID_Data_LONG_2019 <- WIDA_ID_Data_LONG[YEAR=="2019"]
WIDA_ID_Data_LONG_2020 <- WIDA_ID_Data_LONG[YEAR=="2020"]
WIDA_ID_Data_LONG_2021 <- WIDA_ID_Data_LONG[YEAR=="2021"]
WIDA_ID_Data_LONG_2022 <- WIDA_ID_Data_LONG[YEAR=="2022"]
WIDA_ID_Data_LONG <- WIDA_ID_Data_LONG[YEAR < "2019"]

save(WIDA_ID_Data_LONG, file="Data/WIDA_ID_Data_LONG.Rdata")
save(WIDA_ID_Data_LONG_2019, file="Data/WIDA_ID_Data_LONG_2019.Rdata")
save(WIDA_ID_Data_LONG_2020, file="Data/WIDA_ID_Data_LONG_2020.Rdata")
save(WIDA_ID_Data_LONG_2021, file="Data/WIDA_ID_Data_LONG_2021.Rdata")
save(WIDA_ID_Data_LONG_2022, file="Data/WIDA_ID_Data_LONG_2022.Rdata")



