# Felipe Giuste
# 5/10/2019
# Snakefile
# For Testing Snakemake

import glob, os

#-------------------------------------------------------------------------------
# Config
#-------------------------------------------------------------------------------
# Obtain sample names from input directory contents:
SAMPLES = [fname.split('/')[-1].split('.txt')[0] for fname in glob.glob('./testdir/input/*')]
GOODBYES = expand("testdir/output/{sample}/goodbye.txt", sample = SAMPLES)


#-------------------------------------------------------------------------------
# Rules
#-------------------------------------------------------------------------------
#localrules: all, make_goodbyes

rule all:
    input: GOODBYES[0:7]
    shell:
        """
        echo "Final Hello World"
        """

rule make_goodbyes:
    input: "testdir/input/{sample}.txt"
    output: "testdir/output/{sample}/goodbye.txt"
    threads: 1
    resources:
        mem_gb = 5
    shell:
        """
        echo {input};
        sleep 20;
        echo;
        touch {output};
        echo "before Docker";
        docker run hello-world;
        echo "after Docker";
        """

# TODO: create slurm job config file to specify ntasks=1,c=1, manually override for larger jobs
## Also: slurm.conf: CR_CPU -> CR_CPU_Memory

# Run Snakemake:
# nohup snakemake --cores 16 --resources mem_gb=23 --rerun-incomplete &

# snakemake --jobs 256 --cluster "sbatch --ntasks=1 --cpus-per-task=16"
