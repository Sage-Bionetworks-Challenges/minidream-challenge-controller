#!/usr/bin/env cwl-runner
#
# Example validate submission file
#
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python3

hints:
  DockerRequirement:
    dockerPull: sagebionetworks/synapsepythonclient:v2.3.1

inputs:
  - id: synapse_config
    type: File
  - id: submission_id
    type: int

arguments:
  - valueFrom: get_submission.py
  - valueFrom: $(inputs.submission_id)
    prefix: -s

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: .synapseConfig
        entry: $(inputs.synapse_config)
      - entryname: get_submission.py
        entry: |
          #!/usr/bin/env python
          import argparse
          import synapseclient
          parser = argparse.ArgumentParser()
          parser.add_argument("-s", "--submission_id", help="Submission File")

          args = parser.parse_args()
          syn = synapseclient.login()

          syn.getSubmission(args.submission_id, downloadLocation=".")

outputs:
  - id: filepath
    type: File
    outputBinding:
      glob: '*.yml'