## ----setup, cache=FALSE,echo=FALSE---------------------------------------
library(reshape2)
library(ggplot2)
library(ggthemes)

data <- read.csv('individual.csv',header=F)
data.v2 <- melt(data,id.vars=c("V1") )
evaluations <- data.frame(bits=data.v2$V1,evaluations=data.v2$value )

baseline <- read.csv('baseline-ea.csv',header=F,sep=" ")
baseline.v2 <- melt(baseline,id.vars=c("V1"))
baseline.64 <- baseline.v2[baseline.v2$V1==64,]

population <- read.csv('population-concurrency.csv',header=F,sep=" ")
population.v2 <- melt(population,id.vars=c("V1"))
population.64 <- population.v2[population.v2$V1==2,]

comparison.64 <- data.frame(bits=baseline.64$V1,algorithm=rep('Baseline',length(baseline.64$V1)),evaluations=baseline.64$value)
individual.64 <- evaluations[evaluations$bits==64,]

comparison.64 <- rbind(comparison.64,
                       data.frame(bits=population.64$V1,algorithm=rep('Population concurrency',length(population.64$V1)),evaluations=population.64$value))

comparison.64 <- rbind(comparison.64,
                       data.frame(bits=individual.64$bits,algorithm=rep('Individual concurrency',length(individual.64$bits)),evaluations=individual.64$evaluations))


## ----results-mo, cache=FALSE,echo=FALSE----------------------------------
ggplot(evaluations,aes(x=bits,y=evaluations,group=bits))+geom_boxplot()+ scale_y_log10()+theme_tufte()+labs(x="Bits",y="Evaluations",title="Individually concurrent evolutionary algorithm")

## ----population-initial, cache=FALSE,echo=FALSE--------------------------
population.initial <- data.frame(Number=population.v2$V1,Evaluations=population.v2$value)
ggplot(population.initial,aes(x=Number,y=Evaluations,group=Number))+geom_boxplot()+theme_tufte()+labs(x="Number of initial populations",y="Evaluations",title="Comparing population-level concurrent EA for different number of initial populations")+ scale_y_log10()

## ----comparison-mo, cache=FALSE,echo=FALSE-------------------------------
ggplot(comparison.64,aes(x=algorithm,y=evaluations,group=algorithm))+geom_boxplot()+theme_tufte()+labs(x="Algorithm",y="Evaluations",title="Comparing algorithms for the 64 bit onemax problem")+ scale_y_log10()

