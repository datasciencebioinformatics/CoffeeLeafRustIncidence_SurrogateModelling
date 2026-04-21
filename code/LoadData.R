# Load the name opf excel sheets
excel_sheet<-"CLRI_14D"
                                                                                                                                                    
# Take the data.frame for this sheet
df_datapoint<-cbind(time_windows=excel_sheet,data.frame(read_excel(file.path(project_folder, "data/","Coffee_Leaf_Rust_Incidence_modeling_data.xlsx" ), sheet = excel_sheet)))
