##############################################################################
###                                                                        ###
###       WIDA Idaho Learning Loss Analyses -- Create Baseline Matrices    ###
###                                                                        ###
##############################################################################

### Load necessary packages
require(SGP)

### Load Data
load("Data/WIDA_ID_SGP.Rdata")
load("Data/WIDA_ID_Data_LONG_2020.Rdata")

###   Create a smaller subset of the LONG data to work with.
WIDA_ID_SGP_LONG_Data <- updateSGP(WIDA_ID_SGP, WIDA_ID_Data_LONG_2020, steps="prepareSGP")@Data
WIDA_ID_Baseline_Data <- data.table::data.table(WIDA_ID_SGP_LONG_Data[, c("ID", "CONTENT_AREA", "YEAR", "GRADE", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "VALID_CASE"),])

###   Read in Baseline SGP Configuration Scripts and Combine
source("SGP_CONFIG/2020/BASELINE/Matrices/READING.R")

WIDA_ID_BASELINE_CONFIG <- READING_BASELINE.config


###   Create Baseline Matrices

WIDA_ID_SGP <- prepareSGP(WIDA_ID_Baseline_Data, create.additional.variables=FALSE)

WIDA_ID_Baseline_Matrices <- baselineSGP(
				WIDA_ID_SGP,
				sgp.baseline.config=WIDA_ID_BASELINE_CONFIG,
				return.matrices.only=TRUE,
				calculate.baseline.sgps=FALSE,
				goodness.of.fit.print=FALSE,
				parallel.config = list(
					BACKEND="PARALLEL", WORKERS=list(TAUS=4))
)

###   Save results
save(WIDA_ID_Baseline_Matrices, file="Data/WIDA_ID_Baseline_Matrices.Rdata")
