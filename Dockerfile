FROM fallingstar10/beaverworker:latest

# 创建目录并设为工作目录
RUN mkdir /xdxtools

# 复制文件到目标路径（避免覆盖问题）
COPY . /xdxtools

# 安装R包（确保路径与工作目录一致）
RUN R -e "pak::local_install('/xdxtools', upgrade=FALSE, ask=FALSE, dependencies=NA);pak::cache_clean()"

# 直接启动交互式Bash
CMD ["/bin/bash", "-il"]
