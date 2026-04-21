# List all folder in project_folder results
version_folder <- list.dirs(path = file.path(project_folder, "results"), full.names = FALSE, recursive = TRUE)

# Remove empty folder
version_folder<-version_folder[version_folder != ""]

# Data frame to store version control
df_version<-data.frame(Version_txt=c(),Version_int=c())

for (version in version_folder)
{
  print(version)
  # Add version to table
  df_version<-rbind(df_version,data.frame(Version_txt=version,Version_int=as.integer( str_split(version, "_")[[1]][2])))
}

# Store last version
last_version<-paste("Version",df_version[which.max(df_version$Version_int),"Version_int"]+1,sep="_")

# Set project folder
output_dir<-file.path(project_folder, "results",last_version,"/" )

# Start folder
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}
