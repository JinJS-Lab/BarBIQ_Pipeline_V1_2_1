# BarBIQ Pipeline (v1.2.1)

The BarBIQ pipeline is for processing the sequencing data (please note that this code only accept the phred+33 encoding system for the sequencing quality scores) obtained by BarBIQ method to identify Bar sequences (16S rRNA sequences) and cOTUs (cell-based taxa) and to quantify the identified cell numbers of each cOTU. 

This is version 1.2.1\
Author:\
Update: Xiongduo Liu \
Supervisor: Katsuyuki Shiroguchi, Jianshi Jin\ <br/>


## What's new in this version compared to version 1.2.0

In version 1.2.1, we have integrated the pipeline installation into Docker, allowing all necessary software to be automatically installed. We offer **two installation methods**: **building the Docker image with Dockerfile**, or **pulling the pre-built Docker image**.

## Contents
(1) BarBIQ_code: All codes of this pipeline<br/>

(2) Demo: Example data which can be used for demonstration.<br/>
* There are two types of data. The "Data_and_inputfiles_for_whole_processing" data can be used to successively run both BarBIQ_Step_1.pl and BarBIQ_Step_2.pl, but it requires 6 + 0.5 hours of running time; the "Data_and_inputfiles_for_quick_testing" data can be used to quickly test BarBIQ_Step_1.pl in 1 min and BarBIQ_Step_2.pl in 5 min, respectively (we note that this data cannot be used to successively run both BarBIQ_Step_1.pl and BarBIQ_Step_2.pl). <br/>

(3)Expected_output_files: Expected output after this pipeline runs correctly<br/>

(4)Dockerfile: Configuration for buliding docker images

## Codes
The codes of this pipeline is written in Perl (v5.22.1) or in R (version 3.6.3)(only one code). <br/>

## System requirements
(1) Required operation system: Linux 64<br/>

(2) Required software: Perl(tested v5.22.1); R(tested versions 3.5.1, 4.0.2, and 4.1.1); nucleotide-sequence-clusterizer (Version 0.0.7)<br/>

(3) Required perl modules: IPC::System::Simple; File::Path; File::Copy; Parallel::ForkManager; Bio::SeqIO; Bio::Seq; Text::Levenshtein::XS; Text::WagnerFischer; List::Util; Statistics::Basic; Excel::Writer::XLSX; Math::Round; Bundle::BioPerl<br/>
* Perl modules can be installed by the code BarBIQ_check_and_install_modules.pl (see below).<br/>

(4) Required R packages: plotrix<br/>
* R packages can be installed by the code BarBIQ_final_fitting_OD.r during the processing of BarBIQ_Step_2.pl.<br/>

Note: All of these software are automatically installed in version 1.2.1

## Installation

###  Install docker

```
# Ubuntu
sudo apt install docker.io -y
# CentOS
sudo yum install -y docker-ce
# Verify Installation
docker --version
```

### Options for user in China

To use Docker mirrors in China for faster downloads, follow these steps:

1. Open the Docker configuration file `/etc/docker/daemon.json`. If it doesn't exist, create it.
2. Add the following content to the file:

```
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com",
    "https://ccr.ccs.tencentyun.com",
    "https://dockerproxy.com"
  ]
}

```

3. Save the configuration file and restart the Docker service for the changes to take effect:

```
sudo systemctl restart docker
```

4. For older systems like Ubuntu 14.04, use:

```
sudo service docker restart
```

5. After configuring the mirrors, you can test it by pulling an official Ubuntu image:

```
docker pull ubuntu
```

Note: If the configuration is correct, the download speed should be significantly faster.

### Clone the project 

Clone/download this repository to your local computer<br/>
Click "Download ZIP" button<br/>
Or<br/>
Type in the Terminal or equivalent:<br/>

```
git clone https://github.com/JinJS-Lab/BarBIQ_Pipeline_V1_2_1.git
```

### 1 Building the docker image with Dockerfile

#### Build the Docker Image

to navigate to the project directory and build the Docker image, run the following command:

```
cd BarBIQ_Pipeline_V1_2_1
docker build -t jin/barbiq:v1 .
```

Note: Don't forget the last "."



### 2 Pulling the pre-built docker image

#### Pull docker image

To pull the Docker image, run the following command:

```
docker pull jinjslab/barbiq_pipeline:v1
```

Next, change the tag of the image to a shorter name, `barbiq`, for ease of use:

```
docker tag jinjslab/barbiq_pipeline:v1 jin/barbiq:v1
```



## How to use the codes for real data or the demo data "Data_and_inputfiles_for_whole_processing"
### Start and Run the Container

```
# Create a local directory to store data and transfer files within Docker
mkdir /local_data
# Launch Docker
docker run -v /local_data:/root/data -it jin/barbiq:v1 /bin/bash
```

Note: In the above code, `/local_data` can be modified to reflect the user's actual local directory. This directory must contain all input files required for the analysis, including `BarBIQ_example_inputfile_1.txt`, `BarBIQ_example_parameter_1.txt`, `BarBIQ_example_inputfile_2.txt`, `BarBIQ_example_parameter_2.txt`, and `Miseq data`.

### Step 1: For each sequencing run

(A) Modify the "Demo/Data_and_inputfiles_for_whole_processing/BarBIQ_example_inputfile_1.txt" and "Demo/Data_and_inputfiles_for_whole_processing/BarBIQ_example_parameter_1.txt" for your own data (`Data_path` in  `BarBIQ_example_parameter_1.txt` should be updated with the actual path, ensure to adjust path accordingly, even for demonstration purposes. `BarBIQ_example_inputfile_1.txt` should be modified based on the Miseq data and experiment design)<br/>
* Details are explained in the file itself or in Instructions_prepare_input_files.txt<br/>

(B) Type the following command with adjustment of the path, accordingly:<br/>

```
/root/BarBIQ_code/BarBIQ_Step_1.pl --in /root/data/Demo/Data_and_inputfiles_for_whole_processing/BarBIQ_example_inputfile_1_S.txt --p /root/data/Demo/Data_and_inputfiles_for_whole_processing/BarBIQ_example_parameter_1_S.txt
```

Note: In the above code, `Demo/Data_and_inputfiles_for_whole_processing` should be replaced with the actual path where **BarBIQ_example_inputfile_1_S.txt** and **BarBIQ_example_parameter_1_S.txt** are located. 

### Step 2: For all samples
(A) Modify the "Demo/Data_and_inputfiles_for_whole_processing/BarBIQ_example_inputfile_2.txt" and "Demo/Data_and_inputfiles_for_whole_processing/BarBIQ_example_parameter_2.txt" for your own data (`Out_path` in  `BarBIQ_example_parameter_2.txt` should be updated with the actual path, ensure to adjust path accordingly, even for demonstration purposes. `Folder`in`BarBIQ_example_inputfile_2.txt` should be updated with the actual data and others should be modified based on the experiment design)<br/>
* Details are explained in the file itself or in Instructions_prepare_input_files.txt<br/>

(B) Type the following command in the Terminal or equivalent with adjustment of the path, "path-to", accordingly:<br/>
  ```
/root/BarBIQ_code/BarBIQ_Step_2.pl --in /root/data/Demo/Data_and_inputfiles_for_whole_processing/BarBIQ_example_inputfile_2_S.txt --p /root/data/Demo/Data_and_inputfiles_for_whole_processing/BarBIQ_example_parameter_2_S.txt
  ```

Note: In the above code, `/Demo/Data_and_inputfiles_for_whole_processing` should be replaced with the actual path where **BarBIQ_example_inputfile_2_S.txt** and **BarBIQ_example_parameter_2_S.txt** are located. 

## How to quickly test the codes using the demo data "Data_and_inputfiles_for_quick_testing"

### For Step 1
Type the following command:<br/>
  ```
/root/BarBIQ_code/BarBIQ_Step_1.pl --in /root/data/Demo/Data_and_inputfiles_for_quick_testing/For_Step1/BarBIQ_example_inputfile_1_S.txt --p /root/data/Demo/Data_and_inputfiles_for_quick_testing/For_Step1/BarBIQ_example_parameter_1_S.txt
  ```

### For Step 2
Type the following command in the Terminal or equivalent:<br/>
  ```
/root/BarBIQ_code/BarBIQ_Step_2.pl --in /root/data/Demo/Data_and_inputfiles_for_quick_testing/For_Step2/BarBIQ_example_inputfile_2_S.txt --p /root/data/Demo/Data_and_inputfiles_for_quick_testing/For_Step2/BarBIQ_example_parameter_2_S.txt
  ```



## Key output results
### For Step 1
#### (1) Filename end with "_clean_sub1_sub2_shift_link_derr_indels_chimeras_similar_statistic"
* In the output folder of each index of the Step 1 contains the number of droplets (2nd column) for each identified Bar sequence (3rd column); in the 4th column, "LINK" and "I1R2" indicates I1 and R2 are overlapped or not; the numbers in the 5th and 6th columns indicate the numbers of bases obtained from I1 and R2; the numbers in the 1st column are serial number.<br/> 
* For the detailed information, please refer to the "Step 10" in Supplementary Note 2 of [High-throughput identification and quantification of single bacterial cells in the microbiota](https://www.nature.com/articles/s41467-022-28426-1).<br/>

#### (2) Filename end with "_clean_sub1_0.1_sub2_shift_link"
* In the output folder of each index of the Step 1 contains the "SCluster" ID, RepSeqs for I1 reads, RepSeqs for R2 reads, "LINK" or "I1R2" indicating I1 and R2 are overlapped or not, and linked RepSeqs, which is used for identifying multiple Bar sequences from the same bacterium. <br/>
* For the detailed information, please refer to the "Step 15" in Supplementary Note 2 of [High-throughput identification and quantification of single bacterial cells in the microbiota](https://www.nature.com/articles/s41467-022-28426-1).<br/>

#### (3) Filename with "_reads_per_barcode_aveReads_" in the middle
* In the output folder of the Step 1, there are one file per one index; each file contains the detected Barcodes and the number of detected reads for each barcode; the number in the filename after "_aveReads_" indicates the average number of reads per barcode, and the number in the end of the filename indicates the detected number of barcodes.<br/>

### For Step 2
#### (1) "BarBIQ_Quantification.xlsx" 
* In the output folder of the Step 2 contains the raw counted cell numbers, absolute cell numbers per unit weight or volume, and proportional cell abundance of the cOTUs for each sample with the taxonomies predicted by RDP classifier. <br/>
* For the detailed information, please refer to the "ReadMe" sheet in "BarBIQ_Quantification.xlsx". <br/>

#### (2) "BarBIQ_Bar_sequences.xlsx" 
* In the output folder of the Step 2 contains the Bar sequences for all samples with the cOTU information. <br/>
* For the detailed information, please refer to the "ReadMe" sheet in "BarBIQ_Bar_sequences.xlsx". <br/>

#### (3) "BarBIQ_Bar_sequences.fasta"
* In the output folder of the Step 2 contains Bar sequences in fasta format with taxonomic labels (predicted by the RDP classifier) and cOTU ID. <br/>
* This file may be used for other downstream bioinformatic analyses such as phylogenetic tree analysis. <br/>

## Documentation
All the algorithms of this pipeline is described in the paper [High-throughput identification and quantification of single bacterial cells in the microbiota](https://www.nature.com/articles/s41467-022-28426-1).<br/>

## How to cite the BarBIQ pipeline
### Please cite the following three papers:

Jin, J., Yamamoto, R. & Shiroguchi, K. High-throughput identification and quantification of bacterial cells in the microbiota based on 16S rRNA sequencing with single-base accuracy using BarBIQ. Nat Protoc., 19, 207–239 (2024). <br/>

Jin, J., Yamamoto, R., Takeuchi, T., Cui, G., Miyauchi,E., Hojo, N., Ikuta, K, Ohno, H. & Shiroguchi, K. High-throughput identification and quantification of single bacterial cells in the microbiota. Nat. commun., 13, 863, (2022). <br/>

Ogawa, T., Kryukov, K., Imanishi, T. & Shiroguchi, K. The efficacy and further functional advantages of random-base molecular barcodes for absolute and digital quantification of nucleic acid molecules. Sci. Rep., 7, 13576 (2017).<br/>

### If you use the taxonomies for the cOTUs generated by this pipeline, please cite this paper as well:
Wang, Q, Garrity, G. M., Tiedje, J. M. & Cole, J. R. Naïve Bayesian Classifier for Rapid Assignment of rRNA Sequences into the New Bacterial Taxonomy. Appl. Environ. Microbiol. 73(16), 5261-5267 (2007).<br/>

## Other versions
[v1.0.0](https://github.com/Shiroguchi-Lab/BarBIQ)<br/>
[v1.1.0](https://github.com/Shiroguchi-Lab/BarBIQ_Pipeline_V1_1_0)<br/>
[v1.2.0](https://github.com/JinJS-Lab/BarBIQ_Pipeline_V1_2_0)<br/>
