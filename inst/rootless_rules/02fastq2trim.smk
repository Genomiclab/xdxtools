rule fastq2trim:
  message: "Runing fastq2trim ..."
  input:
    R1= lambda wildcards: os.path.join(config["rawDir"], f"{wildcards.sample}_R1.fastq.gz"),
    R2= lambda wildcards: os.path.join(config["rawDir"], f"{wildcards.sample}_R2.fastq.gz")
  output:
    R1 = os.path.join(config["trimDir"], "{sample}"  + "_val_1.fq.gz"),
    R2 =os.path.join(config["trimDir"], "{sample}" + "_val_2.fq.gz"),
    R1report = os.path.join(config["trimDir"], "{sample}" + "_R1.fastq.gz_trimming_report.txt"),
    R2report = os.path.join(config["trimDir"], "{sample}" + "_R2.fastq.gz_trimming_report.txt")
  params:
    dir= config["trimDir"],
    error = config["error"],
    C1=config["C1"],
    C2=config["C2"],
    T1=config["T1"],
    T2=config["T2"],
    adapter1= lambda wildcards: config["trimSeq1"][config["SIDs"].index(wildcards.sample)],
    adapter2= lambda wildcards: config["trimSeq2"][config["SIDs"].index(wildcards.sample)],
    SIDs= lambda wildcards: wildcards.sample
  threads: 6
  shell:
    """
    # 定义变量
    error={params.error}
    threads={threads}
    basename={params.SIDs}
    dir={params.dir}
    input1={input.R1}
    input2={input.R2}
    adapter={params.adapter1}
    adapter2={params.adapter2}
    C1={params.C1}
    C2={params.C2}
    T1={params.T1}
    T2={params.T2}
    
    # 构建trim_galore命令
    command="conda run -n trim_galore trim_galore -e $error -j $threads --basename $basename --paired -o $dir"
    
    # 仅当 adapter 不是 "NO_ADAPTER_CAL_USE_DEFAULT" 时才添加参数
    if [ "$adapter" != "NO_ADAPTER_CAL_USE_DEFAULT" ]; then
        command+=" --adapter $adapter"
    fi
    if [ "$adapter2" != "NO_ADAPTER_CAL_USE_DEFAULT" ]; then
        command+=" --adapter2 $adapter2"
    fi
    
    # 添加输入文件和其他条件参数
    command+=" $input1 $input2"
    
    # 根据条件添加参数
    if [ "$C1" -ne 0 ]; then
    command+=" --clip_R1 $C1"
    fi
    if [ "$C2" -ne 0 ]; then
    command+=" --clip_R2 $C2"
    fi
    if [ "$T1" -ne 0 ]; then
    command+=" --three_prime_clip_R1 $T1"
    fi
    if [ "$T2" -ne 0 ]; then
    command+=" --three_prime_clip_R2 $T2"
    fi
    # 执行命令
    echo $command
    eval $command
    
    """
