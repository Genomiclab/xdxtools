rule construct_expression_matrix :
  message:"Construct expression matrix ..."
  input:
    expand(os.path.join(config["outDir_mCall"], "{sample}" + "_" + config["graft"] + ".txt"), sample=config["SIDs"])
  output:
    os.path.join(config["outDir_betaM"], "matrix_count.txt"),
    os.path.join(config["outDir_betaM"], "matrix_norm.txt")
  params:
    htseq_dir = config["outDir_mCall"],
    output_dir = config["outDir_betaM"],
    postfix = "_" + config["graft"] + ".txt"
  threads:5
  shell:
    """
    conda run -n base Rscript R/htseq2matrix.R --htseq_dir {params.htseq_dir} --output_dir {params.output_dir} --postfix {params.postfix}

    """
   
