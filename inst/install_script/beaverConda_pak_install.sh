conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
conda update -n base -c conda-forge conda
conda install -n base libarchive
conda create -n py27 python=2.7 -y
conda create -n pyfastx -c bioconda pyfastx -y
conda create -n multiqc  -c bioconda multiqc -y
conda install -n base r-base -y
conda install -n multiqc python=3.12.3 -y
conda install -n multiqc numpy=1.26.4 -y
conda create -n star -c bioconda star -y
conda create -n htseq -c bioconda htseq -y
conda create -n bismark -c bioconda bismark -y
conda create -n fastqc -c bioconda fastqc  -y
conda create -n snakemake -c bioconda snakemake  -y
conda create -n qualimap -c bioconda qualimap  -y
conda create -n seqkit -c bioconda seqkit  -y
conda create -n seqtk -c bioconda seqtk  -y
conda create -n trim_galore -c bioconda trim-galore  -y
conda create -n picard -c bioconda picard -y
conda install -n base r-ragg -y
conda install -n base r-tidyverse -y
conda install -n base cmake -y
conda install -n base r-xml2 -y
conda install -n base bioconductor-rhtslib -y
conda install -n base r-magick -y
conda install -n base r-rJava -y
conda install -n base r-devtools
conda install -n base -c conda-forge freetype libcurl icu libjpeg-turbo libpng libtiff libxml2 pandoc -y
conda run -n base R -e "options ('repos' = c(CRAN ='https://mirrors.tuna.tsinghua.edu.cn/CRAN/'));
  install.packages('pak',repos = c(CRAN ='https://mirrors.tuna.tsinghua.edu.cn/CRAN/')) ;
  pak::pkg_install(c('DT','shinyWidgets','shiny','bslib','optparse',
         'openxlsx','NOISeq','XML','Repitools',
                         'Rsamtools','rtracklayer','R6','reticulate',
                         'GSVA','graphite','igraph','ggraph','TCGAbiolinks',
                         'SummarizedExperiment','doParallel','yaml','tinytex',
                         'KEGGgraph', 'plotly',
                         'pROC','sva','glue','fs',
                         'png','reshape2',
                         'readxl','sampling',
                         'umap',
                         'gridExtra','ggpubr',
                         'GenomicRanges','data.table',
                         'clusterProfiler','org.Hs.eg.db',
                         'msigdbr','xlsx','KEGGREST','GenomicDataCommons',
                         'foreach','doMC','Seurat',
                         'dbplyr', 'RColorBrewer',
                         'rjson','mlr3verse',
                         'limma','BSgenome',
                         'BSgenome.Hsapiens.UCSC.hg19','bsseq'),
                       upgrade = F,ask= FALSE, dependencies = NA);
      pak::pkg_install(c('mlr-org/mlr3extralearners@*release'),upgrade = TRUE,ask= FALSE, dependencies = NA);
      pak::pak('NKI-GCF/XenofilteR');
      pak::pak('CompEpigen/scMethrix');
      pak::pak('CompEpigen/methrix');
      pak::pak('blastula');
      devtools::install_github('mlr-org/mlr3proba');
      tinytex::install_tinytex(force = TRUE);
      tinytex::tlmgr_repo('http://mirrors.tuna.tsinghua.edu.cn/CTAN/');
      pak::cache_clean()"
