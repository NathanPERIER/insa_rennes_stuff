# getwd()

variables <- ls()
print("les variables de mon espace personnel sont : ")
print(variables)

pipo <- 'une variable texte'
nombre <- 3
rm(pipo)
help(rm)


txt <- "33"
print(class(txt))

nbr <- as.integer(txt)
print(is.numeric(nbr))

mot <- "petite"
text1 <- paste("une", mot, "phrase")
text2 <- paste(text1, "compte", nchar(text1), "lettres")

tmp <- 3 / 0
nsp <- NA
resultat <- paste(tmp, tmp+1, tmp+nsp) # Inf Inf NA


vecteur1 <- c(1, 3, 5, 7, 9) # initialisation
vecteur2 <- seq(from=0, to=10, by=2) # sequence
vecteur3 <- 0:10 # range
vecteur4 <- rep(1:2, 5) # repeat

v1 <- c(175, 182, 165, 187, 158)
v2 <- c(19, 18, 21, 22, 20)
v3 <- c("Louis", "Paule", "Pierre", "Rémi", "Claude")
tableau <- data.frame(prenom=v3, taille=v1, age=v2)
print(names(tableau))
print(tableau$prenom)
write.table(tableau, "sortie.csv", sep=";",row.names = FALSE, col.names =FALSE)


# norm (loi normale)
# binom (loi binomiale)
# unif (loi uniforme)
# geom (loi géométrique)
# pois (loi de poisson)
# t (loi de Student)
# chisq (loi du chi-deux)
# exp (loi exponentielle)
# f (loi de Fischer)

curve(dnorm(x,mean=1,sd=0.3), from=-1, to=3, ylab="dnorm(x, mean=1)")
curve(dnorm(x,mean=1,sd=0.5), add=T, col="red")
curve(dnorm(x,mean=1,sd=0.7), add=T, col="green")
curve(dnorm(x,mean=1,sd=1.1), add=T, col="blue")
legend(-1, 1.1, legend=c("sigma = 0.3", "sigma = 0.5", "sigma = 0.7", "sigma = 1.1"), col=c("black", "red", "green", "blue"), text.font=2, bg="lightgrey")

x <- 0:10
y <- dbinom(x, size=10, prob=0.2)
plot(x, y, type='h', lwd=30, lend="square", ylab="P(X=x)")

nbElem <- 20
data <- rnorm(nbElem, mean=1, sd=3) # mean : moyenne, sd : écart-type
data

nbElem <- 80
data <- rnorm(nbElem, mean=1, sd=3) 
hist(data, freq=F)

x <- 0:10
curve(dexp(x, rate=2), from=0, to=10, ylab="dexp(x)")
curve(dexp(x, rate=1), add=T, from=0, to=10, ylab="dexp(x)")
curve(dexp(x, rate=0.5), add=T, from=0, to=10, ylab="dexp(x)")
hist(rexp(80, rate=0.5), add=T, freq=F)


de <- 1:6
sample(de, replace=TRUE, size=10)

N <- 1000
n <- 10
p <- 0.3
ech <- rbinom(N, n, p)
barplot(table(ech)/N)


urne <- function(k, p, q) {
	urn <- rep(c("Rouge"), p)
	urn <- c(urn, rep(c("Noire"), q))
	urn <- sample(urn)
	return(sample(urn, replace=FALSE, size=k))
}
result <- urne(6, 8, 5)

freq <- function(n) {
	thr <- sample(1:6, replace=TRUE, size=n)
	count <- 0
	for (x in thr) {
		if(x == 5) {
			count <- count + 1
		}
	}
	return(count/n)
}
print(freq(10))
print(freq(100))
print(freq(1000))
print(1/6)
