##########################################################################################
###
### Script for calculating SGPs for 2018-2019 WIDA/ACCESS Idaho
###
##########################################################################################

### Load SGP package
require(SGP)
options(error=recover)


### Load Data
load("Data/WIDA_ID_SGP.Rdata")
load("Data/WIDA_ID_Data_LONG_2019.Rdata")

### Modify SGPstateData temporarily
SGPstateData[["WIDA_ID"]][["Growth"]][["System_Type"]] <- "Cohort Referenced"

### Run analyses
WIDA_ID_SGP <- updateSGP(
		WIDA_ID_SGP,
		WIDA_ID_Data_LONG_2019,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "visualizeSGP", "outputSGP"),
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		get.cohort.data.info=TRUE,
		sgp.target.scale.scores=TRUE,
		plot.types=c("growthAchievementPlot", "studentGrowthPlot"),
		sgPlot.demo.report=TRUE,
		parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4, GA_PLOTS=1, SG_PLOTS=1)))


### Save results

save(WIDA_ID_SGP, file="Data/WIDA_ID_SGP.Rdata")
