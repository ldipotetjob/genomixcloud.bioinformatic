##README.md Prokka


prokka $fasta_contigs_genome_file --outdir $path_out/${single_pattern}_annotation \
--prefix $single_pattern --locustag $single_pattern --cpus $cpus --force
cp $path_out/${single_pattern}_annotation/*.gff /genx-poc/$request_id/annotation_gff

docker run --name prokka --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
staphb/prokka:latest prokka /data/data_fna/v1_genomic.fna --outdir /data/data_gff/v1_annotation \
--locustag contigs --cpus 8


docker run --name prokka --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
staphb/prokka:latest prokka /data/data_fasta/contigs.fasta --outdir /data/data_gff/contigs_annotation \
--locustag contigs --cpus 8 

