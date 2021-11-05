library(rje)

# 2.1
data = c(0.02, 0.06, 0.02, 0.10, 0.04, 0.15, 0.2, 0.1, 0.01, 0.15, 0.14, 0.01)
mat <- matrix(data, nrow=3, ncol=4, byrow=TRUE, dimnames = list(c("X0", "X5", "X10"), c("Y0", "Y5", "Y10", "Y15")))

# 2.2
prob_x <- as.vector(apply(mat, 1, sum)) # as.vector(tapply(matrice, rep(1:3,4), sum))

# 2.3
prob_y <- as.vector(apply(mat, 2, sum)) # as.vector(tapply(matrice, rep(1:4,each=3), sum))

# 2.4
# Formule de Bayes ?
prob_x_y5 <- c(mat[1:3,2])/prob_y[2]

# 2.5
prob_x <- as.vector(marginTable(mat, 1))
prob_y <- as.vector(marginTable(mat, 2))
mat_x_y <- conditionTable(mat, 1, 2)
prob_x_y5 <- as.vector(mat_x_y[,2])

# 2.6
# P(rouge) = P(noire) = 18/38 = 9/19
# P(verte) = 2/38 = 1/19
# Xi ~ Ber((9/19, 9/19, 1/19)) i allant de 1 à 12, 12 varaibles iid
# X = (X1, X2, ..., X12) ~ Mult(12, (9/19, 9/19, 1/19))

# 2.7
R <- expand.grid(0:12, 0:12)
R[, 3] <- 12 - R[, 1] - R[, 2]
R[, 4] <- rep(c(0), 13^2)
names(R) <- c("x1", "x2", "x3", "p")
for (i in 1:(13^2)) {
	if (R$x3[i] >= 0) {
		R$p[i] = dmultinom(c(R$x1[i], R$x2[i], R$x3[i]), size = 12, prob = c(9/19, 9/19, 1/19))
	}
}

# 2.8 
probas_x3 <- rep(c(0), 13)
for (i in 1:length(R[,"x3"])) {
	x3 <- R[i,"x3"]
	if(x3 >= 0) {
		probas_x3[x3+1] <- probas_x3[x3+1] + R[i,"p"]
	}
}
print(probas_x3)
print(sum(probas_x3))


# illustration
library(scatterplot3d)
par(cex.main = 1.5, cex.axis = 1.2, cex.lab = 2, col.axis = "blue")
scatterplot3d(x = R$x1, y = R$x2, z = R$x3,
	color = gray(0.9 - R$p*5), type = "p",
	xlab = "x_1", pch = 16,
	ylab = "x_2", zlab = "x_3", cex.symbol = 2.5)
title("Fonction de masse de la loi multinomiale\ncouleur sombre = probabilité forte")


# 2.9
library(questionr)
dHDV <- data.frame(hdv2003)
mhour <- tapply(dHDV$heures.tv, dHDV$age, mean)
hours <- c()
ages <- c()
for(i in 1:length(mhour)) {
	if(!is.na(mhour[i])) {
		ages <- c(ages, labels(mhour[i]))
		hours <- c(hours, mhour[i])
	}
}
plot(ages, hours, ylab="Average hours spent watching TV", xlab="Age (years)")

# 2.10
library(ggplot2)
ggplot(dHDV) +
	aes(x = age, y = heures.tv) +
	geom_count(colour = "red", alpha = .2) +
	xlab("Âge") +
	ylab("Heures quotidiennes de télévision") +
	labs(size = "effectifs")
# Pour tous les âges, on observe de fortes bandes à 2,4 et 2,6 h
# Utiliser une moyenne (?)

# 2.11
# Je n'arrive pas à charger rp99

# 2.12
# library(GGally)
# ggpairs(rp99[, c("hlm", "locataire", "maison", "proprio")])

# 2.13
# ggcorr(rp99)

# 3.1
library(mnormt)
library(rgl)
library(lattice)
library(emdbook)
library(mnormt)
library(mvtnorm)

Moy <- c(0, 0)
MatCov <- matrix(c(1, 0, 0, 1), nrow=2, ncol=2)

x <- seq(-4,4,0.1)
y <- seq(-4,4,0.1)
f <- function(x,y) {
	dmnorm(cbind(x,y), Moy, MatCov)
}
z <- outer(x,y,f) # permet d’appliquer une fonction à chaque couple de deux vecteurs

# Visualisation classique
persp(x,y,z, box=T,axes=T, ticktype="detailed", theta=40,phi=0)
persp(x,y,z, theta=30,phi=50)
persp(x,y,z, theta=100,phi=40,col="blue")
wireframe(z)

# Visualisation 3D
R <- as.matrix(expand.grid(x, y))
z<-dmvnorm(R,mean=Moy,sigma=MatCov)
col1 <- rainbow(length(z))[rank(z)]
curve3d(dmvnorm(c(x,y),mean=Moy,sigma=MatCov),sys3d="rgl",col=col1,xlim=c(-3,3),ylim=c(-3,3))


# 3.2 
library(MASS)
plot(geyser$duration, geyser$waiting)

# 3.3
image(kde2d(geyser$duration, geyser$waiting))
persp(kde2d(geyser$duration, geyser$waiting))
contour(kde2d(geyser$duration, geyser$waiting))
# ???
