
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Beaverdown2: A Bioinformatics Workflow Management Package

## 简介

`Beaverdown2` 是一个基于 R
的生物信息学工作流管理工具包，旨在简化和自动化复杂的生物信息学分析流程。它结合了
R6 类和 Snakemake 工作流引擎，支持多种分析模式（如 RRBS、WGBS 和
RNAseq），并能够运行在不同的计算环境中（如 Kubernetes、Slurm
和容器化环境）。通过
`Beaverdown2`，用户可以轻松配置、管理和执行生物信息学分析任务，同时支持
PDX/CDX（患者/细胞系来源异种移植）分析流程。

## 功能介绍

### 核心功能

1.  **多模式支持**
    - RRBS（Reduced Representation Bisulfite Sequencing）
    - BSseq（Bisulfite Sequencing）
    - RNAseq（RNA Sequencing）
    - PDX/CDX（患者/细胞系来源异种移植）分析流程
2.  **多环境支持**
    - Kubernetes
    - Slurm
    - 容器化环境（如 Docker）
3.  **自动化工作流管理**
    - 自动生成配置文件
    - 自动创建必要的目录结构
    - 支持多步骤工作流（如数据预处理、比对、分析等）
4.  **丰富的工具集成**
    - Bismark、HTSeq、FastQC、Qualimap 等
    - 支持 XenofilteR 用于 PDX/CDX 数据分析
    - 支持 Methrix 和 scMethrix 用于甲基化分析及RRBS数据插补
5.  **结果聚合与下载**
    - 自动聚合分析结果
    - 支持压缩下载（如 ZIP 或 GZIP）
6.  **通知与日志**
    - 通过电子邮件发送任务进度通知
    - 详细记录运行日志

### 其他功能

- **内存和 CPU 检测**
  - 提供当前会话的内存和 CPU 核心检测功能。
- **文件操作**
  - 支持文件压缩、聚合和远程同步。
- **DNA 序列操作**
  - 提供 DNA 序列的反向互补计算功能。

## 安装

### 从Github 安装

``` r
pak::pak("Rhtslib")
pak::pak('CompEpigen/scMethrix')
pak::pak('CompEpigen/methrix')
pak::pak("BiocParallel")
pak::pak("NKI-GCF/XenofilteR")
pak::pak("rainoffallingstar/beaverdown2")
```

### **安装依赖**

`Beaverdown2` 需要以下依赖项：

- R 4.0 或更高版本

- Conda（用于环境管理，我们提供了原生支持的函数`beaverflow_install`
  以初始化Conda 环境）

- Docker（如果需要使用 Kubernetes
  或预装的容器化环境`fallingstar10/beaverstudio:latest`）

安装完成后，运行以下命令以配置工作流目录与环境：

    library(Beaverdown2) 
    beaverflow_install(workflow_dir = "/path/to/your/workflow_dir",build_env = T)

## **使用方法**

### **初始化工作流**

    library(Beaverdown2)  
    gandalf_RRBS <- BeaverGandalf$new(Mode = "RRBS",
                                     species1 = "human",    
                                     species2 = "mouse",                  
                                      uploadfile = use_sever_fastq(serverpath = "/project/PDX_COAD_STAD"),
                                      pdata = use_server_pdata(serverpath = "/config/20240923.xlsx"),
                                      workflow_endpoint = "3",
                                      user_email = "whoami@qq.com")

### **运行工作流**

    # 处理fastq 文件
    gandalf_RRBS$gandalf_fastq_move(method = "copy") # 可以改进为move
    # 初始化运行目录
    gandalf_RRBS$gandalf_create_filework()
    # 向运行目录写入config文件
    gandalf_RRBS$gandalf_make_config()
    # 调用snakemake 运行指定流程
    gandalf_RRBS$gandalf2wars(dry_run = F,snakemake_condaenv = "snakemake",use_sbatch = F)

### **聚合结果**

    # 聚合结果并压缩 
    gandalf_RRBS$gandalf_aggResult(resultType = "matrix", method = "zip")

### **更新工作流**

    update_gandalf(gandalf_RRBS)

## **支持与反馈**

如果在使用过程中遇到问题，请随时通过以下方式联系开发者：

- 提交 GitHub Issues

## **许可**

`Beaverdown2` 采用 MIT 许可证。
