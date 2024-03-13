set -e
true
true
/SPAdes-3.15.5-Linux/bin/spades-hammer /data/data_out/corrected/configs/config.info
/usr/bin/python /SPAdes-3.15.5-Linux/share/spades/spades_pipeline/scripts/compress_all.py --input_file /data/data_out/corrected/corrected.yaml --ext_python_modules_home /SPAdes-3.15.5-Linux/share/spades --max_threads 16 --output_dir /data/data_out/corrected --gzip_output
true
true
/SPAdes-3.15.5-Linux/bin/spades-core /data/data_out/K21/configs/config.info /data/data_out/K21/configs/careful_mode.info
/SPAdes-3.15.5-Linux/bin/spades-core /data/data_out/K33/configs/config.info /data/data_out/K33/configs/careful_mode.info
/SPAdes-3.15.5-Linux/bin/spades-core /data/data_out/K55/configs/config.info /data/data_out/K55/configs/careful_mode.info
/SPAdes-3.15.5-Linux/bin/spades-core /data/data_out/K77/configs/config.info /data/data_out/K77/configs/careful_mode.info
/SPAdes-3.15.5-Linux/bin/spades-core /data/data_out/K99/configs/config.info /data/data_out/K99/configs/careful_mode.info
/SPAdes-3.15.5-Linux/bin/spades-core /data/data_out/K127/configs/config.info /data/data_out/K127/configs/careful_mode.info
/usr/bin/python /SPAdes-3.15.5-Linux/share/spades/spades_pipeline/scripts/copy_files.py /data/data_out/K127/before_rr.fasta /data/data_out/before_rr.fasta /data/data_out/K127/assembly_graph_after_simplification.gfa /data/data_out/assembly_graph_after_simplification.gfa /data/data_out/K127/final_contigs.fasta /data/data_out/contigs.fasta /data/data_out/K127/first_pe_contigs.fasta /data/data_out/first_pe_contigs.fasta /data/data_out/K127/strain_graph.gfa /data/data_out/strain_graph.gfa /data/data_out/K127/scaffolds.fasta /data/data_out/scaffolds.fasta /data/data_out/K127/scaffolds.paths /data/data_out/scaffolds.paths /data/data_out/K127/assembly_graph_with_scaffolds.gfa /data/data_out/assembly_graph_with_scaffolds.gfa /data/data_out/K127/assembly_graph.fastg /data/data_out/assembly_graph.fastg /data/data_out/K127/final_contigs.paths /data/data_out/contigs.paths
true
true
/usr/bin/python /SPAdes-3.15.5-Linux/share/spades/spades_pipeline/scripts/correction_iteration_script.py --corrected /data/data_out/contigs.fasta --assembled /data/data_out/misc/assembled_contigs.fasta --assembly_type contigs --output_dir /data/data_out --bin_home /SPAdes-3.15.5-Linux/bin
/usr/bin/python /SPAdes-3.15.5-Linux/share/spades/spades_pipeline/scripts/correction_iteration_script.py --corrected /data/data_out/scaffolds.fasta --assembled /data/data_out/misc/assembled_scaffolds.fasta --assembly_type scaffolds --output_dir /data/data_out --bin_home /SPAdes-3.15.5-Linux/bin
true
/usr/bin/python /SPAdes-3.15.5-Linux/share/spades/spades_pipeline/scripts/breaking_scaffolds_script.py --result_scaffolds_filename /data/data_out/scaffolds.fasta --misc_dir /data/data_out/misc --threshold_for_breaking_scaffolds 3
true
