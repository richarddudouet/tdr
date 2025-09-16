#____________________________________________________________________________----
#____________________________________________________________________________----
#____________________________________________________________________________----
#         CORRECTION DU TD1 ---- 
#____________________________________________________________________________----
#____________________________________________________________________________----
#____________________________________________________________________________----
# Date de création: 19/09/2025
# Date de dernière modification: 19/09/2025

# Pour créer un commentaire dans le script, il suffit d'écrire # avant d'écrire.



# 0. Setup ----
#__________----

# 0.Commencez par créer un projet en haut à droite
# 0.Creez 3 fichiers Data, Scripts, Results dans le fichier directeur

## a. Packages à charger (après les avoir installés)----
library(readr)
library(readxl) 
library(tidyverse)
library(Hmisc)
library(DataExplorer)

## b. Environnement à charger----
load(file = "TD1/envtd1.RData")
#.----
#.----



# 1. Importation des bases de données ----
#___________________________----

## a. Commandes d'importations----
##________________
### Utilisez le bouton import Dataset et copier coller la commande
# A copier coller dans le script pour la REPRODUCTIBILITE


### i. Importation de la première base----

# Une fonction dans R est toujours sous la forme nomdelafonction(argument)
 nhanes <- read_excel("TD1/Data/nhanes.xlsx") 
#### En français : Créé un objet nhanes dans lequel du mettra ce fichier excel en data frame.

 #### oo. Pour connaitre les arguments d'une fonction----
?read_excel
#ou
help(read_excel)



### ii. Importation de la deuxième base----

data_educ <- read_delim("TD1/Data/data_educ.csv", 
                        delim = ";", escape_double = FALSE, trim_ws = TRUE)
#Attention ici l'argument délim permet de dire à R que les valeurs sont séparés par des ; et pas par des virgules. 





#.----
#.----
# 2. Joindre les bases de données ----
#__________________________----

## a. Copier les dataframes et les renommer----
##________________
d<-nhanes # prend nhanes et met le dans d
d=nhanes # le nouvel objet en premier
d_educ=nhanes_educ


## b. Décrire succintement les dataframes----
##________________
# str 
str(d) # Mais disponible en cliquant sur la flèche dans environnement

# Describe de Hmisc :
library(Hmisc)
describe(d)

# Create report de DataExplorer
library(DataExplorer)
create_report(data=d)
create_report(data=d_educ)



## c. Vérifier les différences entre les dataframes----
##________________
### i. Différence de nombre de ligne----
nrow(d)-nrow(d_educ) # nrow=littéralement nombre de ligne

### ii. Y a t il bien une ligne par ID ? ----
summary(
  object=duplicated(x=d_educ$ID)) # Une fonction dans une fonction !
# Dans r summary permet de faire un résumé en s’adaptant à l’objet qu’on lui donne en argument.
# Ici il va compter combien sont présent plus d’une fois (TRUE) et combien sont présent qu’une fois (FALSE).
##.----



## d. Joindre les deux dataframes en fonction de ID et de number_survey  ----
##________________

# Je choisi left_join
#____________________
?left_join
d_s1=left_join(x=d, 
               y=d_educ, 
               by=c("ID", "number_survey")) 
# Permet de ne garder que les lignes de d_educ matchant avec les lignes de d par leur ID et leur number_survey. 


# Description argument par argument : 
#_____________________________________
d_s1=left_join(x=d, # Le premier dataframe dont on veut garder toutes les lignes
               y=d_educ, # Le deuxième dataframe dont on veut sup des lignes
               by=c("ID", "number_survey")) # On veut garder les lignes si les élément de d_educ ont le même ID et le même nombre de number_survey. Quant on veut mettre plusieurs élément dans un argument, c'est la qu'on utilise le vecteur ! 


# N'oubliez pas pour verifier: 
#______________________________
summary(d_join$number_survey) # Il ne sont que = 1 !
# Summary donne ici le résumé d'une variable numérique (donc la description habituelle pour une variable num.)


#.----
#.----
# 3. Enregistrer notre environnement et notre base----
#__________________________----
## a. Notre environnement----
save.image("C:/Users/richa/Desktop/Travail/4. Enseignement/td_r/TD1/Data/envtd1.RData")
# Enregistre tout nos objets

## b. Notre base----
saveRDS(d_join,
        file="TD1/Data/d_complete_s1.rds")
# Enregistre la base sous format r. 


#.----
#.----
#4. Tidyverse----
#__________________________----
# Permet de coder dans le même sens qu'on pense. 

v <- c(1.2, 8.7, 5.6, 11.4) 

# Si on veut faire la moyenne de v arrondi, la formater sous un résultat à la française, créer une phrase avec le résultat puis l'afficher dans la console. 

v %>%    
  mean() %>%  # parfois on est pas obligé de mettre le place holder. 
  round(digits = 1) %>% 
  format(decimal.mark = ",") %>%
  paste0("La moyenne est de ",.,".") %>%  
  message()

# Traduction en français :
# Prend V PUIS
# Fais la moyenne PUIS
# Arrondi la PUIS
# Formate là à la française PUIS
# Colle ce message au résultat des fonctions d'avant PUIS
# Affiche le dans la console. 

## a. Trouver facilement une variable (exemple avec Education)----
##________________________
d %>% 
  select(starts_with("edu") | contains("edu")) %>% 
  names()
# Prend d puis
# selectionne les variables qui commencent par ou contiennent "edu" puis
# donne moi leur noms

# Dans d_educ : 
d_educ %>% 
  select(starts_with("edu") | contains("edu")) %>% 
  names() 
# Prend d_educ puis
# selectionne les variables qui commencent par ou contiennent "edu" puis
# donne moi leur noms




## b. Filtrer un dataframe avant de le joindre----
##________________________
# Dans un objet d_join
# Prend d_educ PUIS
# Filtre ou créer un sous ensemble avec ceux dont number_survey==1 PUIS
# Join le avec le dataframe d en fonction de ID.

d_join=d_educ %>% 
  subset(number_survey==1) %>% 
  full_join(d, 
            .,
            by=c("ID",
                 "number_survey")) # Je le remet ici pour eviter la duplication

# Verifiez qu'il n'y a pas de ligne rajouté par rapport à d. 


