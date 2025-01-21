library(optparse)
library(methrix)
library(dplyr)
library(BSgenome)
option_list = list(make_option(c("--filein"), type = "character", default = NULL, help = "CpG Island BED file, provided by default."),
                   make_option(c("--fileout"), type = "character", default = "human", help = "species1, provided by default."),
                   make_option(c("--cores"), type = "character", default = "10", help = "cores, provided by default."))
args = commandArgs(trailingOnly=F)
args <- parse_args(OptionParser(option_list = option_list))
# 获取命令行参数
filein <- args$filein
fileout <- args$fileout
cores <- args$cores %>% 
  as.numeric()
message(fileout)
fs::dir_create(fileout)
temp_dir <- paste0(fileout,"temp")
fs::dir_create(temp_dir)

hg19_cpgs = methrix::extract_CPGs(ref_genome = "BSgenome.Hsapiens.UCSC.hg19")
bismark_covfiles <- list.files(path = filein,"*.bismark.cov.gz$",full.names = T)
meth = methrix::read_bedgraphs(files = bismark_covfiles, 
                               ref_cpgs = hg19_cpgs, 
                               chr_idx = 2, 
                               start_idx = 3, 
                               M_idx = 5, 
                               U_idx = 6,
                               stranded = TRUE, 
                               collapse_strands = TRUE,
                               pipeline = "Bismark_cov",
                               zero_based=FALSE,
                               n_threads = cores, 
                               h5 = TRUE, 
                               h5_dir = fileout, 
                               h5temp = temp_dir,
                               vect = F)
#fs::dir_delete(temp_dir)

meth %>% 
  methrix::convert_HDF5_methrix() %>% 
  methrix::methrix2bsseq() %>% 
  saveRDS(.,
          file = paste0(fileout,"/bsseq.RDS"))