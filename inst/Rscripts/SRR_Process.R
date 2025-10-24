Rscript -e '
# 加载所需包
library(stringr)
library(dplyr)
library(fs)
library(glue)

wds <- c("/public3/home/scg9946/SRP1016")
for (wd in wds) {
  if (!dir.exists(wd)) dir.create(wd, recursive = TRUE)
  setwd(wd)
  if (!dir.exists("out")) dir.create("out")

  SRRs <- list.files(full.names = FALSE)
  SRRs <- SRRs[grepl("SRR",SRRs)]
  processed_SRRs <- list.files("out/", full.names = FALSE) %>%
    str_remove(., "_1.fastq.gz") %>%
    str_remove(., "_2.fastq.gz")

  # 修正 setdiff 和过滤逻辑
  need_SRRs <- setdiff(SRRs, processed_SRRs)  # 直接使用 SRRs 无需 basename
  SRRs <- SRRs[SRRs %in% need_SRRs]  # 简化过滤

  for (i in seq_along(SRRs)) {
    sra_id <- SRRs[i]
    cmd <- glue(
      "srun -p amd_512 -N1 -n1 --cpus-per-task=10 --mem=100G \\
       conda run -n sratools parallel-fastq-dump \\
       --sra-id {sra_id} --threads 10 --outdir out/ --split-files --gzip"
    )
    message("\n>> Processing ", sra_id, " (", i, "/", length(SRRs), ")")
    message(">> Command: ", cmd)
    tryCatch({
      system(cmd, intern = TRUE)
      message(">> ", sra_id, " completed")
    }, error = function(e) message("!! Error: ", e$message))
  }

  # 重命名文件
  message(">> Preparing Fastq files")
  files <- list.files(path = "out/", full.names = TRUE)
  files_rename <- files %>%
    str_replace("_1.fastq.gz", "_R1.fastq.gz") %>%
    str_replace("_2.fastq.gz", "_R2.fastq.gz")
  for (i in seq_along(files)) {
    file_move(files[i], files_rename[i])
  }
}
' > download3.log 2>&1 &
