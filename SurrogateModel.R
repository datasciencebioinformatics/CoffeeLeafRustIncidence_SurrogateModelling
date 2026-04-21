
# Plot experimental data
fig_experimental_all      <- plot_ly(x = df_datapoint$tAvg14.1, y = df_datapoint$hMin14.1, z = df_datapoint$cCLRI, type = 'mesh3d',colorscale = "Viridis", opacity = .60,intensity = df_datapoint$cCLRI)

# Experimental figure
fig_experimental_all <- fig_experimental_all %>% layout(
    xaxis = list(title = "tAvg"),
    yaxis = list(title = "hMin"))

#########################################################################################################
# KNN model 
# Train models discrete data                                                  
Formula_cCLRI_Model_1 = as.formula("cCLRI ~ hMin14.1 + tAvg14.1")
###########################################################################################################
# Split in trainning and testing sets
trainning_id<-sample(rownames(df_datapoint), size=round(length(rownames(df_datapoint))*0.8), replace = FALSE)
testing_id  <-rownames(df_datapoint)[!rownames(df_datapoint) %in% trainning_id]

# 1. Configurar o método de reamostragem (Validação Cruzada)
# define trainControl
# Define train control parameters (e.g., 10-fold cross-validation)
# Custom summary function for MRE 
# Custom summary function for MRE
mreSummary <- function(data, lev = NULL, model = NULL) {
	rmse=rmse(data$obs, data$pred) 
	mae=mae(data$obs, data$pred)
	mre=mre(data$obs, data$pred) 
	cor=cor(data$obs, data$pred)
  c(MRE = mre, RMSE=rmse, MAE = mae, Cor=cor)
}
# 6. Model for combination of parameter
model_comb_rf <- caret::train(Formula_cCLRI_Model_1, data = df_datapoint[trainning_id,c("cCLRI", "hMin14.1", "tAvg14.1")], method = "ranger", trControl = train_control)
model_comb_lm <- caret::train(Formula_cCLRI_Model_1, data = df_datapoint[trainning_id,c("cCLRI", "hMin14.1", "tAvg14.1")], method = "lm", trControl = train_control)
model_comb_bn <- tabu(df_datapoint[trainning_id,c("cCLRI", "hMin14.1", "tAvg14.1")])
model_comb_bn = bn.fit(model_comb_bn, df_datapoint[trainning_id,c("cCLRI", "hMin14.1", "tAvg14.1")])


# Calculate the predictions from knn, lm, bn
lm_CLRI_pred_Model_1_test      <-predict(model_comb_lm, newdata =  df_datapoint[testing_id,c("cCLRI", "hMin14.1", "tAvg14.1")])
rf_CLRI_pred_Model_1_test      <-predict(model_comb_rf, newdata =  df_datapoint[testing_id,c("cCLRI", "hMin14.1", "tAvg14.1")])
bn_CLRI_pred_Model_1_test      <-predict(model_comb_bn, data = df_datapoint[testing_id,c("cCLRI", "hMin14.1", "tAvg14.1")], node="cCLRI", method = "parents")

# Make one dispersion plots
# knn versus observed
# lm versus observed
# bn versus observed
df_results_CLRI<-rbind(data.frame(Observed=df_datapoint[testing_id,c("cCLRI")],Predicted=rf_CLRI_pred_Model_1_test,Method="rf"),
data.frame(Observed=df_datapoint[testing_id,c("cCLRI")],Predicted=lm_CLRI_pred_Model_1_test,Method="lr"),
data.frame(Observed=df_datapoint[testing_id,c("cCLRI")],Predicted=bn_CLRI_pred_Model_1_test,Method="bn"))
      
#create plot with regression line and regression equation
p1<-ggplot(data=df_results_CLRI, aes(x=Observed, y=Predicted)) +
        geom_point()    + facet_wrap(~ Method,nrow=3) + theme_bw()  + stat_cor(r.digits=5) 


# bwplot               
png(filename=paste(output_dir,"predicted_Observed.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # Plot the bayesian network graph
  p1
dev.off()

######################################################################################################################
# Step 3: Create a Grid of Feature Values
# Define the grid limits for head

# Define the grid limits for H
Model_1_x_min_T <- 10
Model_1_x_max_T <- 30
Model_1_z_min_H <- 50
Model_1_z_max_H <- 100
                                                  
# Create a grid of values
space_variable <- expand.grid(tAvg14.1 = seq(10, 30, by = 0.5),hMin14.1 = seq(50, 100, by = 1))


#######################################################################################################################
# For each element of the grid, predict the efficiency, H, and the n                                                  
# either use a for loop or knn function
rf_CLRI_pred_Model_1_test      <-predict(model_comb_rf, newdata = space_variable)

# Df results
df_results<-data.frame(tAvg14=space_variable$tAvg14,hMin14.1=space_variable$hMin14.1,CLRI=rf_CLRI_pred_Model_1_test)

######################################################################################################################
# Define x, y, z coordinates

                                                                                       
library(rgl)
fig_final <- plot_ly(x = space_variable$tAvg14, y =space_variable$hMin14.1, z = rf_CLRI_pred_Model_1_test, type = 'mesh3d',colorscale = "Viridis", opacity = .60,intensity = rf_CLRI_pred_Model_1_test)
######################################################################################################################   
