library(MASS)

print(michelson$Speed)

# 1.1
mean(michelson$Speed)	# moyenne
sd(michelson$Speed)		# écart-type (standard derivation)

# 1.2
sum <- 0.0
averages <- c()
i <- 0
for(x in michelson$Speed) {
	sum <- sum + x
	i <- i + 1
	averages <- c(averages, sum / i)
}
plot(1:100, averages, type="l")

# 1.3
# On grade la valeur moyenne = 852.4
# Théorème des grands nombres (?)

# 1.4
n=length(michelson$Speed)
hist(michelson$Speed, freq=F) # répartition ressemble à une courbe en cloche
curve(dnorm(x,mean=mean(michelson$Speed),sd=sd(michelson$Speed)), from=600, to=1100, add=T,col="blue") 
# sd/sqrt(100)? Non car on prend la valeur mesurée, pas une valeur théorique calculée à partir de la loi de Xi car on ne la connaît pas
# Tout ce que nous dit le théorème central limite dans ce cas c'est que la moyenne suit une loi normale


# 2.1
n <- 5000
tirages <- rbinom(n, 10, 1/4)
count <- 0
i <- 0
averages <- c()
for(x in tirages) {
	i <- i+1
	if(x >= 6) {
		count <- count + 1
	}
	averages <- c(averages, count/i)
}
plot(1:n, averages, type="l")

# 2.2
# Loi de Bernoulli, p=1/4

# 2.3
# Loi binomiale, n=10, p=1/4

# 2.4
# P = P(X=6) + P(X=7) + P(X=8) + P(X=9) + P(X=10)
# p <- dbinom(6, 10, 1/4) + dbinom(7, 10, 1/4) + dbinom(8, 10, 1/4) + dbinom(9, 10, 1/4) + dbinom(10, 10, 1/4)
#   = P(X>=6) = 1 - P(X<6) = 1 - P(X<=5)
p <- 1 - pbinom(5, 10, 1/4)
print(paste("P(X>=6) =", p))

# 2.5
# sigma(/X10) = sigma(1/10 * X) = sqrt((1/10)² 10*(1/4)*(3/4)) = 1/10 * sqrt(30)/4
# loi normale, mu = 1/4, sd = sqrt((1/4)(3/4))/sqrt(10) = sqrt(3/10)/4

# P = P(X>=6) = 1 - P(X<6) = 1 - P(X<5)
# Ce n'est pas comme ça que fonctionnnent les probas continues mais on fait l'approximation quand même
p2 <- 1 - pnorm(0.5, mean=1/4, sd=sqrt(3/10)/4)
print(paste("P(/X10>=6) ~=", p2))
# De toute façon ça ne fonctionne dans aucun des deux cas 
p2 <- 1 - pnorm(0.6, mean=1/4, sd=sqrt(3/10)/4)
print(paste("P(/X10>=6) ~=", p2))
# Noter que pour une raison étrange, la moyenne des deux donne une bonne approximation

# 2.6

