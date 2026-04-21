## Framework for CoffeeLeaf Rust Incidence simulation with surrogate models
##############################################################
### 0. Pré-processamento
#### 0.1) Configurações do projeto (diretórios)
source("C:/Users/felip/OneDrive/Documentos/GitHub/CoffeeLeafRustIncidence_SurrogateModelling/config/Project_Configuration.txt")

#### 0.2) Pacotes R utilizados
source(paste(project_folder,"/code/Load_All_R_Packages.R",sep=""))

#### 0.3) Set fixed random seed 
set.seed(06042026)

#### 0.4) Set output folder according to version
source(paste(project_folder,"/code/Version_Control.R",sep=""))

##############################################################
### 1. Load data
#### 0.4) Set output folder according to version
source(paste(project_folder,"/code/LoadData.R",sep=""))





