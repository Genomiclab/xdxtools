rule picard_pdx_patch:
  message : "for PDX pipeline,patching ..."
  input:
    bam_sorted = lambda wildcards:os.path.join(config["bsmapDir"], f"{wildcards.sample}_"+f"{wildcards.species}"+".bam")
  output:
    os.path.join(config["bsmapDir"], "{sample}_{species}_pdx_patch_success")
  params:
    marker = lambda wildcards:os.path.join(config["bsmapDir"], f"{wildcards.sample}_"+f"{wildcards.species}"+"_pdx_patch_success"),
    bam_fixed = lambda wildcards:os.path.join(config["bsmapDir"], f"{wildcards.sample}_fixed_"+f"{wildcards.species}"+".bam"),
    fasta = lambda wildcards:config["gnome_fasta"][config["species"].index(wildcards.species)]
  threads:4
  run:
        if config["Mode"] == "RNASEQ":
            shell(
                """
                java -jar /picard/picard.jar SetNmMdAndUqTags \
                I={input.bam_sorted} \
                O={params.bam_fixed} \
                R={params.fasta} \
                IS_BISULFITE_SEQUENCE=false
                
                touch {params.marker}
                """
            )
        else:
            shell(
                """
                java -jar /picard/picard.jar SetNmMdAndUqTags \
                I={input.bam_sorted} \
                O={params.bam_fixed} \
                R={params.fasta} \
                IS_BISULFITE_SEQUENCE=true 
                
                touch {params.marker}
                """
            )
