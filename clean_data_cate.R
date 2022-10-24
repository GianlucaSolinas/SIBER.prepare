# read file
t <- read.csv('./Downloads/Borkum 2020.csv')

# set NA instead of zero-values
t[t == 0] <- NA

cols <- list(reference = c('N_RfB20', 'C_RfB20'), rock = c('N_RcB20', 'C_RcB20'), lanice = c('N_LnB20','C_LnB20'))

recurrent_species <- list()

# for each column, collect all unique species where "col" definition (N_**** & C_****) are not NA
for(col in cols){
  recurrent_species <- append(recurrent_species, list(unique(t[rowSums(is.na(t[col])) != ncol(t[col]), c("Species")])))
}

species_names <- Reduce(intersect, recurrent_species)

community_counter <- 1

all_ <- list()

for(name in names(cols)){
  # get only needed columns
  ddata <- t[t$Species %in% species_names, c("Species", cols[[name]])]
  ddata_clean <- na.omit(ddata)
  
  # add community column with value
  ddata_clean$community <- community_counter
  
  # rename columns
  names(ddata_clean) <- c("group", "iso1", "iso2", "community")
  
  # reorder columns
  ddata_clean <- ddata_clean[,c(2,3,1,4)]
  
  # add to final list of datasets
  all_ <- append(all_, list(ddata_clean))
  
  # add 1 to community counter
  community_counter <- community_counter + 1
}

# merge all
final <- Reduce(rbind, all_)

# write csv if you want
# write.csv(final, './Downloads/final_test.csv', row.names = FALSE)

