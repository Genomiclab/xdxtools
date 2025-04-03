
library(optparse)
library(BiocParallel)
library(dplyr)
option_list = list(make_option(c("-d", "--filter_root"), type = "character", default = NULL, help = "CpG Island BED file, provided by default."),
                   make_option(c("--graft"), type = "character", default = "human", help = "species1, provided by default."),
                   make_option(c("--host"), type = "character", default = "mouse", help = "species1, provided by default."),
                   make_option(c("--MM_threshold"), type = "character", default = "6", help = "species1, provided by default."),
                   make_option(c("--Unmapped_penalty"), type = "character", default = "8", help = "species1, provided by default."),
                   make_option(c("--threads"), type = "character", default = NULL, help = "species2, provided by default."),
                   make_option(c("--Mode"), type = "character", default = "RRBS", help = "species2, provided by default.")
                   )
args = commandArgs(trailingOnly=F)
args <- parse_args(OptionParser(option_list = option_list))
# 获取命令行参数
filter_root <- args$filter_root
graft <- args$graft
host <- args$host
threads <- args$threads
MM_threshold <- as.numeric(args$MM_threshold)
Unmapped_penalty  <- as.numeric(args$Unmapped_penalty)
mode <- args$Mode
# 打印参数以确认
cat("Filter root:", filter_root, "\n")
cat("Graft:", graft, "\n")
cat("host:", host, "\n")
cat("threads:",threads, "\n")

if (mode == "RNASEQ"){
  samples <- list.files(filter_root,
                        pattern = "*.bam$",
                        full.names = F) %>%
    stringr::str_remove(.,glue::glue("_{graft}.bam")) %>%
    stringr::str_remove(.,glue::glue("_{host}.bam")) %>%
    stringr::str_remove(.,glue::glue("_fixed")) %>%
    unique()

  sample.list <- data.frame(
    samples = samples
  ) %>%
    dplyr::mutate(Graft = paste0(filter_root,"/",samples,"_fixed_",graft,".bam")) %>%
    dplyr::mutate(Host = paste0(filter_root,"/",samples,"_fixed_",host,".bam")) %>%
    dplyr::select(-samples)
}else{
  samples <- list.files(filter_root,"_val_1_bismark_bt2_PE_report.txt",recursive = T) %>%
    stringr::str_remove(.,"_val_1_bismark_bt2_PE_report.txt") %>%
    stringr::str_remove(.,paste0(host,"/")) %>%
    stringr::str_remove(.,paste0(graft,"/")) %>%
    unique()
  sample.list <- data.frame(
    samples = samples
  ) %>%
    dplyr::mutate(Graft = paste0(filter_root,"/",samples,"_fixed_",graft,".bam")) %>%
    dplyr::mutate(Host = paste0(filter_root,"/",samples,"_fixed_",host,".bam")) %>%
    dplyr::select(-samples)
}


bp.param <- SnowParam(workers = as.numeric(threads), type = "SOCK")
tryerror <- try(fs::dir_delete(paste0(filter_root,"/Filtered_bams")))
XenofilteR::XenofilteR(sample.list = sample.list,
                       destination.folder =filter_root,
                       bp.param = bp.param, output.names = NULL,
                       MM_threshold=MM_threshold,
                       Unmapped_penalty = Unmapped_penalty )
