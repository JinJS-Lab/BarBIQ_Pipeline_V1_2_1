# 使用Ubuntu官方镜像作为基础镜像
FROM ubuntu:latest
# 设置工作目录（提前设置以减少后续WORKDIR调用）
WORKDIR /root
# 拷贝barbiq_code目录到镜像的/root/目录下
COPY ./BarBIQ_code /root/BarBIQ_code

# 进入barbiq_code目录并递归设置所有文件为可执行权限
RUN chmod -R +x /root/BarBIQ_code/*
#安装软件源
# 更新软件包列表并安装必要的系统工具
RUN echo "#中科大" > /etc/apt/sources.list.d/ustc.sources && \
	echo "Types: deb" >> /etc/apt/sources.list.d/ustc.sources && \
	echo "URIs: http://mirrors.ustc.edu.cn/ubuntu/" >> /etc/apt/sources.list.d/ustc.sources && \
	echo "Suites: noble noble-updates noble-security" >> /etc/apt/sources.list.d/ustc.sources && \
	echo "Components: main restricted universe multiverse" >> /etc/apt/sources.list.d/ustc.sources && \
	echo "Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg" >> /etc/apt/sources.list.d/ustc.sources && \
	apt-get update -qq  && \
    apt-get install -y apt-utils curl gnupg2 locales unzip libssl-dev build-essential&& \
    locale-gen zh_CN.UTF-8


# 下载并安装 Miniconda
RUN curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh \
    && chmod +x miniconda.sh \
    && ./miniconda.sh -b -p /usr/local/miniconda \
    && rm miniconda.sh

# 将 Miniconda 的 bin 目录添加到 PATH 环境变量中
ENV PATH=/usr/local/miniconda/bin:$PATH

# 设置生物信息学 Conda 源
# 更新 Conda 并安装 rdptools
RUN conda config --add channels bioconda \
    && conda config --add channels conda-forge \
    && conda config --set channel_priority strict \
	&& conda update -n base -c defaults conda \
	&& conda install -y perl=5.22.0 perl-bioperl r-base rdptools

#安装cpanm
# 设置镜像
# 安装Perl模块
RUN curl -L https://cpanmin.us | perl - --self-contained App::cpanminus && \
	echo 'alias cpanm="cpanm --mirror http://mirrors.163.com/cpan --mirror-only"' >>~/.bashrc && \
	cpanm --notest IPC::System::Simple File::Path File::Copy Parallel::ForkManager Text::WagnerFischer \
	Statistics::Basic Excel::Writer::XLSX Math::Round Bundle::BioPerl List::Util Text::Levenshtein::XS

#设置生物信息学包路径
ENV PERL5LIB=/usr/local/miniconda/lib/perl5/site_perl/5.22.0:$PERL5LIB
# 安装R包 r-base
# 安装nucleotide-sequence-clusterizer
RUN Rscript -e 'install.packages("plotrix", repos="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")' && \
	curl -L -o nucleotide-sequence-clusterizer-0.0.7-linux64.zip \
http://kirill-kryukov.com/study/tools/nucleotide-sequence-clusterizer/files/nucleotide-sequence-clusterizer-0.0.7-linux64.zip && \
unzip nucleotide-sequence-clusterizer-0.0.7-linux64.zip && \
rm -fr nucleotide-sequence-clusterizer-0.0.7-linux64.zip && \
rm -fr /root/nucleotide-sequence-clusterizer-0.0.7-linux64/src

# 安装完成后，可以运行您的应用或命令
CMD ["conda", "run", "-n", "base", "rdpTools"]
