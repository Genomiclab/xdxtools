nohup Rscript -e '
wds <- c("/public3/home/scg9946/rna_pdxdata/SRP302257");
for (wd in wds) {
  if (!dir.exists(wd)) dir.create(wd, recursive=TRUE);
  setwd(wd);
  if (!dir.exists("out")) dir.create("out");
  SRRs <- list.files(full.names=F);
  SRRs = SRRs[!(SRRs == "out")];
  for (i in seq_along(SRRs)) {
    sra_id <- SRRs[i];
    cmd <- glue::glue(
      "srun -p amd_512 -N1 -n1 --cpus-per-task=10 --mem=100G \\
       conda run -n sratools parallel-fastq-dump \\
       --sra-id {sra_id} --threads 20 --outdir out/ --split-files --gzip"
    );
    message("\n>> Processing ", SRRs[i], " (", i, "/", length(SRRs), ")");
    message(">> Command: ", cmd);
    tryCatch({
      system(cmd, intern=TRUE);
      message(">> ", SRRs[i], " completed");
    }, error=function(e) message("!! Error: ", e$message));
  };
  message(">> Preparing Fastq files");
  files <- list.files(path = paste0(wd,"/out/"),
                    full.names = T);
  library(dplyr);
  files_rename <- stringr::str_replace(files,"_1.fastq.gz","_R1.fastq.gz") %>%
  stringr::str_replace(.,"_2.fastq.gz","_R2.fastq.gz");
  for (i in 1:length(files)){
    `fs::file_move(path = files[i],
                new_path = files_rename[i])
  }
}
' > download3.log 2>&1 &
