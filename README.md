# FastScreen [![license](https://img.shields.io/badge/license-MIT-brightgreen)](https://github.com/pegi3s/pss-fs) [![dockerhub](https://img.shields.io/badge/hub-docker-blue)](https://github.com/pegi3s/pss-fs) [![compihub](https://img.shields.io/badge/hub-compi-blue)](https://www.sing-group.org/compihub/explore/5d5bb64f6d9e31002f3ce30a)
> FastScreen is a [compi](https://www.sing-group.org/compi/) pipeline to identify datasets that likely show evidence for positive selection and thus should be the subject of detailed, time-consuming analyses<sup>1</sup>. A Docker image is available for this pipeline in [this Docker Hub repository](https://hub.docker.com/r/pegi3s/pss-fs).

## Pipeline implementation

### File `pipeline-single-file.xml`

The FastScreen compi pipeline is defined in the file `pipeline-single-file.xml`, which is used to analyze one input FASTA file (`<input_dir>/<input_fasta>`) and produce the results at the specified `working_dir`. 

First, ClustalOmega and FastTree are executed in order to look for evidence for positive selection with FUBAR. If evidence for positive selection is found, then the name of the file is added to the `short_list` file. If it is not found, then the file is analized using CodeML. The tasks related with the execution of CodeML can be skipped by passing the parameter `skip_code_ml`.

Please, note that there is a limit around 90 000 for the product of the number of sequences times the number of ungapped codons that CodeML can handle<sup>1</sup>. When this limit is exceeded a random sample is taken from the initial dataset (in the `codeml-check-limit` task). In these cases, as many as possible sequences minus one are used.

### File `pipeline.xml`

Then, a second compi pipeline is defined in the `pipeline.xml` file in order to perform the analysis of several FASTA files in parallel. This pipeline simply runs the `pipeline-single-file.xml` for every FASTA file in the `input_dir` directory and produces the results at the specified `working_dir`. The main output is the `short_list` file, which contains the names of the FASTA files where evidence for positive selection.

Appart from the `short_list` file, six other output files are produced:
1. `FUBAR_short_list`: contains the names of the files where evidence for positive selection has been found by FUBAR.
2. `to_be_reevaluated_by_codeML`: contains the names of the files that where re-evaluated by CodeML.
3. `codeML_random_list`: contains the names of the files from which a random sequence sample was taken because they were too large to be analysed by CodeML.
4. `codeML_short_list`: contains the names of the files where PSS were detected by CodeML model M2a.
5. `negative_list`: contains the names of the files where no evidence for positive selection was found by either FUBAR or CodeML.
6. `files_requiring_attention`: contains the names of the files that could not be processed without error (usually because they have in frame stop codons that were introduced during the nucleotide alignment step). 

## Running the pipeline with sample data

It is possible to test the pipeline using the sample data available [here](resources/test-data). Download the FASTA files and put them in a directory with name `compi-fss-working-dir/input` in your local file system. `compi-fss-working-dir` is the name of the working directory of the pipeline where the output results and intermediate files will be created.

Then, run the following command, changing the `/path/to/compi-fss-working-dir` to the actual path in your file system.

```bash
WORKING_DIR=/path/to/compi-fss-working-dir

mkdir -p ${WORKING_DIR}/logs

docker run -v ${WORKING_DIR}:/working_dir --rm pegi3s/pss-fs --logs /working_dir/logs
```

To re-run the pipeline, clear the working directory with:

```bash
sudo rm -rf ${WORKING_DIR}/ali ${WORKING_DIR}/renamed_seqs ${WORKING_DIR}/logs ${WORKING_DIR}/tree ${WORKING_DIR}/FUBAR_files ${WORKING_DIR}/FUBAR_results ${WORKING_DIR}/short_list ${WORKING_DIR}/to_be_reevaluated_by_codeML ${WORKING_DIR}/codeML_random_list ${WORKING_DIR}/codeML_results ${WORKING_DIR}/tree.codeML ${WORKING_DIR}/codeML_short_list ${WORKING_DIR}/negative_list ${WORKING_DIR}/files_requiring_attention ${WORKING_DIR}/FUBAR_short_list && mkdir -p ${WORKING_DIR}/logs
```

## References
1. H. López-Fernández; P. Duque; N. Vázquez; F. Fdez-Riverola; M. Reboiro-Jato; C.P. Vieira; J. Vieira (2019) [Inferring Positive Selection in Large Viral Datasets](https://doi.org/10.1007/978-3-030-23873-5_8). 13th International Conference on Practical Applications of Computational Biology & Bioinformatics: PACBB 2019. Ávila, Spain. 26 - June 