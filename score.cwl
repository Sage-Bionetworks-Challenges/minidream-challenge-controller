#!/usr/bin/env cwl-runner
#
# Example score submission file
#
cwlVersion: v1.0
class: CommandLineTool
baseCommand: [Rscript, /score.R]

hints:
  DockerRequirement:
    dockerPull: docker.synapse.org/syn4990358/minidream-scoring:v1

requirements:
  InlineJavascriptRequirement: {}

inputs:
  - id: input_file
    type: File
  - id: check_validation_finished
    type: boolean?

arguments:
  - valueFrom: $(inputs.input_file.path)
    prefix: -f
  - valueFrom: results.json
    prefix: -r

outputs:
  - id: results
    type: File
    outputBinding:
      glob: results.json

  - id: status
    type: string
    outputBinding:
      glob: results.json
      loadContents: true
      outputEval: $(JSON.parse(self[0].contents)['submission_status'])
