rule rnaseq_splicing:
    message: "RNA Splicing ..."
    input:
        expand(os.path.join(config["bsmapDir"], "{sample}_{species}.bam"), sample=config["SIDs"], species=config["species"])
    output:
        os.path.join(config["bsmapDir"], "RNASplicing", "RNASplicing_success.txt")
    params:
        run_dir=config["bsmapDir"],
        pdata=os.path.join(config["selfconfig"], "pdata.xlsx"),
        seqlengthQC=config["qcDir"],
        gtf=config["rnaseq_gtf"][config["species"].index(config["graft"])],
        log_marker=os.path.join(config["bsmapDir"], "RNASplicing", "RNASplicing_success.txt"),
        log_dir=os.path.join(config["bsmapDir"], "RNASplicing"),
        pdxmode=(0 if not config["PDX_pipeline"] else 1)
    threads: 20
    run:
        if config["group_levels"] >= 2:
            shell(
                """
                conda run -n base \
                  Rscript R/RNA_Splicing.R \
                  --root {params.run_dir} \
                  --threads {threads} \
                  --pdata {params.pdata} \
                  --seqlengthQC {params.seqlengthQC} \
                  --gtf {params.gtf} \
                  --pdxmode {params.pdxmode}
                echo "RNASplicing_DONE" > {params.log_marker}
                """
            )
        else:
            shell(
                """
                mkdir -p {params.log_dir}
                echo "RNASplicing_NOTRUN" > {params.log_marker}
                """
            )
