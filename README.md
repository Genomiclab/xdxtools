
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Beaverdown2: A Bioinformatics Workflow Management Package

[中文](https://github.com/rainoffallingstar/beaverdown2/blob/main/README_zh.md)

## Introduction

`Beaverdown2` is an R-based bioinformatics workflow management package
designed to simplify and automate complex bioinformatics analysis
pipelines. It integrates R6 classes and the Snakemake workflow engine,
supports multiple analysis modes (such as RRBS, WGBS, and RNAseq), and
can run in various computing environments (e.g., Kubernetes, Slurm, and
containerized environments). With `Beaverdown2`, users can easily
configure, manage, and execute bioinformatics analysis tasks, including
support for PDX/CDX (Patient/Cancer Cell Line Derived Xenograft)
analysis pipelines.

## Features

### Core Features

1.  **Multi-Mode Support**
    - RRBS (Reduced Representation Bisulfite Sequencing)
    - WGBS (Whole Genome Bisulfite Sequencing)
    - RNAseq (RNA Sequencing)
    - PDX/CDX (Patient/Cancer Cell Line Derived Xenograft) analysis
      pipeline
2.  **Multi-Environment Support**
    - Kubernetes
    - Slurm
    - Containerized environments (e.g., Docker)
3.  **Automated Workflow Management**
    - Automatic generation of configuration files
    - Automatic creation of necessary directory structures
    - Support for multi-step workflows (e.g., data preprocessing,
      alignment, analysis)
4.  **Rich Tool Integration**
    - Bismark, HTSeq, FastQC, Qualimap, etc.
    - Support for XenofilteR for PDX/CDX data analysis
    - Support for Methrix and scMethrix for methylation analysis and
      RRBS data imputation
5.  **Result Aggregation and Download**
    - Automatic aggregation of analysis results
    - Support for compressed downloads (e.g., ZIP or GZIP)
6.  **Notifications and Logging**
    - Email notifications for task progress
    - Detailed logging of workflow execution

### Additional Features

- **Memory and CPU Detection**
  - Functions to detect memory and CPU core usage in the current
    session.
- **File Operations**
  - Support for file compression, aggregation, and remote
    synchronization.
- **DNA Sequence Manipulation**
  - Functions to compute the reverse complement of DNA sequences.

## Installation

### Install from GitHub

``` r
pak::pak("rainoffallingstar/beaverdown2")
```

### **Dependencies**

`Beaverdown2` requires the following dependencies:

- R version 4.0 or higher

- Conda (for environment management; we provide a native function
  `beaverflow_install` to initialize the Conda environment)

- Docker (if using Kubernetes or the pre-built container environment
  `fallingstar10/beaverstudio:latest`)

After installation, configure the workflow directory and environment by
running:

    library(Beaverdown2) 

    beaverflow_install(workflow_dir = "/path/to/your/workflow_dir", build_env = TRUE)

## **Usage**

### **Initialize Workflow**

    library(Beaverdown2) 
    gandalf_RRBS <- BeaverGandalf$new(
    Mode = "RRBS", 
    species1 = "human",     
    species2 = "mouse",
    graft = "human",
    uploadfile = use_sever_fastq(serverpath = "/project/PDX_COAD_STAD"),     
    pdata = use_server_pdata(serverpath = "/config/20240923.xlsx"),     
    workflow_endpoint = "3",     
    user_email = "whoami@qq.com"
    )

### **Run Workflow**

    # Process fastq files 

    gandalf_RRBS$gandalf_fastq_move(method = "copy")  # another option is "move" 

    # Initialize the workflow directory

    gandalf_RRBS$gandalf_create_filework() 

    # Write the configuration file to the workflow directory 
    gandalf_RRBS$gandalf_make_config() 

    # Call Snakemake to run the specified workflow 

    gandalf_RRBS$gandalf2wars(
    dry_run = FALSE, 
    snakemake_condaenv = "snakemake", 
    partition = "amd_512",
    use_sbatch = FALSE)

    # use_sbatch works in slurm cluster,if False,srun command will be used.
    # partition param is only used in the slurm cluster mode

### **Aggregate Results**

    # Aggregate results and compress

    gandalf_RRBS$gandalf_aggResult(resultType = "matrix", method = "zip")

### **Update Workflow**

    update_gandalf(gandalf_RRBS)

## **Support and Feedback**

If you encounter any issues during usage, please contact the developer
via the following methods:

- Submit GitHub Issues

## **License**

`Beaverdown2` is licensed under the MIT License.
