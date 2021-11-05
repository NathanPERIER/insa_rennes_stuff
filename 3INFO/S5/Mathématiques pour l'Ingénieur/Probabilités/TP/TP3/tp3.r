# 1.1
x1 <- rnorm(10000, mean = 0, sd = 1)
x2 <- rnorm(10000, mean = 0, sd = 1)
x3 <- rnorm(10000, mean = 0, sd = 1)
x4 <- rnorm(10000, mean = 0, sd = 1)
x5 <- rnorm(10000, mean = 0, sd = 1)
lesValeurs <- c()
for(i in 1:10000) {
	lesValeurs <- c(lesValeurs, x1[i]^2 + x2[i]^2 + x3[i]^2 + x4[i]^2 + x5[i]^2)
}

# 1.2
hist(lesValeurs, freq=F)

# 1.3
curve(dchisq(x, 5), from=0, to=25, add=T,col="blue")

# 2.1 / 2.4
n <- 1000	#6
z <- rnorm(10000, mean = 0, sd = 1)
lesValeurs <- rnorm(10000, mean = 0, sd = 1) ^ 2
for(i in 1:(n-1)) {
	lesValeurs <- lesValeurs + rnorm(10000, mean = 0, sd = 1) ^ 2
}
lesValeurs <- z / sqrt(lesValeurs / n)

# 2.2
hist(lesValeurs, freq=F)

# 2.3
curve(dt(x, n), from=-10, to=10, add=T,col="blue")

# 3.1
setwd("/home/nathan/Documents/INSA Rennes 2020-2021/Probabilités/TP3")
mydata <- read.csv("./vitesse.csv", sep=";", dec = ",", header=TRUE, numerals = "no.loss") 
mydata$vecNum <- as.factor(mydata$vecNum)
mydata$vecVitesses <- as.numeric(mydata$vecVitesses)

# 3.2
vars <- tapply(mydata$vecVitesses, mydata$vecNum, var)

# 3.3
vars_n_sigma2 <- vars*6/100
hist(vars_n_sigma2, freq=F)
curve(dchisq(x,5), add=T,col="blue")

# 4.1
# vars <- vars*6/5
means <- tapply(mydata$vecVitesses, mydata$vecNum, mean)
sds <- tapply(mydata$vecVitesses, mydata$vecNum, sd)
quartiles1 <- c()
quartiles2 <- c()
aplha <- 0.05
min <- aplha/2
max <- 1-min
n <- 6
for(i in 1:length(means)) {
	# quartiles1 <- c(quartiles1, qnorm(min, mean = means[i], sd = sds[i]))
	# quartiles2 <- c(quartiles2, qnorm(max, mean = means[i], sd = sds[i]))
	quartiles1 <- c(quartiles1, means[i] + qt(min, n-1)*sds[i]/sqrt(n))
	quartiles2 <- c(quartiles2, means[i] + qt(max, n-1)*sds[i]/sqrt(n))
}

# 4.2
cpt <- 0
actualMean <- 120
for(i in 1:length(means)) {
	if ((actualMean < quartiles1[i]) || (actualMean > quartiles2[i])) {
		cpt <- cpt + 1
	}
}
print(cpt/length(means))

# 4.3
range <- seq(40)
plot.new()
plot(c(quartiles1[range],quartiles2[range]), c(range, range),
     main="Mean confidence interval", pch=4, col="red",
     xlab="Runtime (s)", ylab="Week number")
segments(quartiles1[range], range, quartiles2[range], range, col="grey")
segments(actualMean, 0, actualMean, length(range), col="green")

# 5.1
vars <- tapply(mydata$vecVitesses, mydata$vecNum, var)
inf_var <- c()
sup_var <- c()
for(i in 1:length(vars)) {
	sup_var <- c(sup_var, (n-1)*vars[i]/qchisq(min, n-1))
	inf_var <- c(inf_var, (n-1)*vars[i]/qchisq(max, n-1))
}

# 5.2
inf_sd <- sqrt(inf_var)
sup_sd <- sqrt(sup_var)
cpt <- 0
actual_sd <- 10
for(i in 1:length(sds)) {
	if ((actual_sd < inf_sd[i]) || (actual_sd > sup_sd[i])) {
		cpt <- cpt + 1
	}
}
print(cpt/length(sds))

# 5.3
range <- seq(40)
plot.new()
plot(c(inf_sd[range],sup_sd[range]), c(range, range),
     main="Mean confidence interval", pch=4, col="red",
     xlab="Runtime (s)", ylab="Week number")
segments(inf_sd[range], range, sup_sd[range], range, col="grey")
segments(actual_sd, 0, actual_sd, length(range), col="green")




