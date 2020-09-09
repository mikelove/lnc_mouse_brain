RUNS, = glob_wildcards("/pine/scr/m/i/milove/{run}_1.fastq.gz")

SALMON = "/proj/milovelab/bin/salmon-1.3.0_linux_x86_64/bin/salmon"

ANNO = "/proj/milovelab/anno"

rule all:
  input: expand("quants/{run}/quant.sf", run=RUNS)

rule salmon_index:
    input: "{ANNO}/gencode.vM25.transcripts.fa.gz"
    output: directory("{ANNO}/gencode.vM25-salmon_1.3.0")
    shell: "{SALMON} index --gencode -p 8 -t {input} -i {output}"

rule salmon_quant:
    input:
        r1 = "/pine/scr/m/i/milove/{sample}_1.fastq.gz",
        r2 = "/pine/scr/m/i/milove/{sample}_2.fastq.gz",
        index = "/proj/milovelab/anno/gencode.vM25-salmon_1.3.0"
    output:
        "quants/{sample}/quant.sf"
    params:
        dir = "quants/{sample}"
    shell:
        "{SALMON} quant -i {input.index} -l A -p 8 --gcBias "
        "--numGibbsSamples 30 --thinningFactor 100 "
        "-o {params.dir} -1 {input.r1} -2 {input.r2}"
