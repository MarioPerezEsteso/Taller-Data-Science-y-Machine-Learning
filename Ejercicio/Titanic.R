# Estableder el directorio de trabajo:
setwd("~/Projects/Taller-Data-Science-y-Machine-Learning/Ejercicio/")
# Importar los datos:
load("titanic.raw.rdata")
# Importar librerías:
library(Matrix)
# Si el paquete utilizado para reglas de asociación no está instalado, hay que ejecutar esta instrucción para instalarlo.
# install.packages("arules")
library(arules)

# Ya que el dataset titanic.raw es relativamente grande, es conveniene utilizar la función 'head()' 
# para mostrar las 6 primeras filas.
#  head(titanic.raw)
#  rules = apriori(titanic.raw)

# Para saber más acerca de la función 'apriori()', introducir en consola:
# ?apriori

rules <- apriori(titanic.raw, 
                 parameter = list(minlen=2, supp=0.005, conf=0.8), 
                 appearance = list(rhs=c("Survived=No", "Survived=Yes"), default="lhs"), 
                 control = list(verbose=F))

rules.sorted <- sort(rules, by="lift")

inspect(rules.sorted)

# Eliminando reglas redundantes:
# En el resultado anterior, la regla 2 no ofrece un conocimiento adicional sobre la regla 1. 
# Debido a esto, podemos decir que la regla 2 debe ser eliminada porque es una superregla de la 1.

# Encontrar reglas redundantes automáticamente.
subset.matrix <- is.subset(rules.sorted, rules.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
which(redundant)

# Eliminar las reglas redundantes.
rules.pruned <- rules.sorted[!redundant]
inspect(rules.pruned)
require(ggplot2)

# Visualización de las reglas:
# install.packages("arulesViz")

library(arulesViz)

# plot(rules.pruned)
# plot(rules.pruned, method="graph", control=list(type="items"))
# plot(rules.pruned, measure=c("support", "lift"), shading="confidence", interactive=TRUE)

# Histograma
transactions <- as(titanic.raw["Survived"], "transactions")
itemFrequencyPlot(transactions,type="relative")
