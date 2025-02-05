# Este código contém comandos para filtrar e plotar os dados de aluguel de bikes, 
# dados que estão em nosso dataset.
# Este código foi criado para executar tanto no Azure, quanto no RStudio.
# Para executar no Azure, altere o valor da variavel Azure para TRUE. 
# Se o valor for FALSE, o codigo sera executado no RStudio.

# Obs: Caso tenha problemas com a acentuação, consulte este link:
# https://support.rstudio.com/hc/en-us/articles/200532197-Character-Encoding

# Configurando o diretório de trabalho
# Coloque entre aspas o diretório de trabalho que você está usando no seu computador
# Não use diretórios com espaço no nome


# Variável que controla a execução do script
Azure = FALSE

if(Azure){
  restaurantes <- maml.mapInputPort(1)
  ratings <- maml.mapInputPort(2) 
}else{
  projeto_path = "D:/FCDados/[13] - Data Munging/[03] - Projetos/"
  input_path = "D:/FCDados/[13] - Data Munging/[01] - InputData/"
  output_path = "D:/FCDados/[13] - Data Munging/[02] - OutputData/"
  setwd(projeto_path)
  getwd()
  restaurantes  <- read.csv("Restaurant-features.csv", sep = ",", header = T, stringsAsFactors = F )
  ratings <- read.csv("Restaurant-ratings.csv", sep = ",", header = T, stringsAsFactors = F)
}

# Filtrando o dataset restaurantes
restaurantes <- restaurantes[restaurantes$franchise == 'f' & restaurantes$alcohol != 'No_Alcohol_Served', ]

require(dplyr)

# Combinando os datasets com base em regras
df <- as.data.frame(restaurantes %>%
                       inner_join(ratings, by = 'placeID') %>%
                       select(name, rating) %>%
                       group_by(name) %>%
                       summarize(ave_Rating = mean(rating)) %>%
                       arrange(desc(ave_Rating))) 
df

if(Azure) maml.mapOutputPort("df")


