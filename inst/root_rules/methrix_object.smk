rule create_methrix_object :
  message:"Build beta matrix ..."
  input:
    expand(os.path.join(config["outDir_mCall"], "{sample}_nsort.bismark.cov.gz"),sample = config["SIDs"])
  output:
    os.path.join(config["outDir_mCall"], "methrixh5","assays.h5"),
    os.path.join(config["outDir_mCall"], "methrixh5","se.rds"),
    os.path.join(config["outDir_mCall"], "methrixh5","bsseq.RDS"),
    os.path.join(config["outDir_mCall"], "methrixh5","CpG_coverage.xlsx")

  params:
    mcall_dir = config["outDir_mCall"],
    methrix_dir = os.path.join(config["outDir_mCall"], "methrixh5"),
    genome = config["genomeAnno"][config["species"].index(config["graft"])]
  threads:10
  shell:
    """
      Rscript R/build_methrix.R \
      --filein {params.mcall_dir} \
      --fileout {params.methrix_dir} \
      --cores {threads} \
      --Genome {params.genome}

    """
   




    
