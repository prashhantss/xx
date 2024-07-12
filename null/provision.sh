apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  name: resource-provisioning-workflow
spec:
  entrypoint: main
  arguments:
    parameters:
      - name: mainRepo
        value: https://github.bnsf.com/HY/infra-demo.git
      - name: rootPath
        value: /
      - name: branch
        value: master
      - name: cmd
        value: '"{\"cmdConfig\":{\"account\":\"nonprod\",\"env\":\"dev\",\"region\":\"southcentralus\",\"stacks\":[\"resource-group\",\"virtual-network\"]}}"'
      - name: correlationId
        value: 123456789
      - name: from
        value: webhook
      - name: csp
        value: azure
      - name: workflowTags
        value: DISABLE_OPA, DISABLE_COST, ENABLE_RELEASE, ENABLE_APPLY

  templates:
    - name: main
      steps:
        - - name: set-flags
            template: set-flags
        - - name: prepare
            template: prepare
        - - name: plan
            template: plan
        - - name: gates
            template: gates
            when: "{{steps.set-flags.outputs.parameters.DISABLE_OPA}} == false"
          - name: cost
            template: cost
            when: "{{steps.set-flags.outputs.parameters.DISABLE_COST}} == false"
        - - name: release
            template: release
            when: "{{steps.set-flags.outputs.parameters.ENABLE_RELEASE}} == true"
        - - name: apply
            template: apply
            when: "{{steps.set-flags.outputs.parameters.ENABLE_APPLY}} == true"

    - name: set-flags
      script:
        image: python:3.8
        command: [python]
        source: |
          import sys, json

          tags = "{{workflow.parameters.workflowTags}}".split(', ')
          flags = {
              "DISABLE_OPA": "DISABLE_OPA" in tags,
              "DISABLE_COST": "DISABLE_COST" in tags,
              "ENABLE_RELEASE": "ENABLE_RELEASE" in tags,
              "ENABLE_APPLY": "ENABLE_APPLY" in tags
          }

          for key, value in flags.items():
              print(f"{{{{outputs.parameters.{key}}}}}={value}")

      outputs:
        parameters:
          - name: DISABLE_OPA
            valueFrom:
              path: /tmp/DISABLE_OPA
          - name: DISABLE_COST
            valueFrom:
              path: /tmp/DISABLE_COST
          - name: ENABLE_RELEASE
            valueFrom:
              path: /tmp/ENABLE_RELEASE
          - name: ENABLE_APPLY
            valueFrom:
              path: /tmp/ENABLE_APPLY

    - name: prepare
      container:
        image: bnsfecpfndnonprodacr.azurecr.io/cloudops-workflow-step-cli:v2.16
        command: [bash, '-ce']
        args:
          - ./create-properties.sh
            ./cli-app.sh prepare
        env:
          - name: MAIN_REPO
            value: '{{workflow.parameters.mainRepo}}'
          - name: ROOT_PATH
            value: '{{workflow.parameters.rootPath}}'
          - name: BRANCH_NAME
            value: '{{workflow.parameters.branch}}'
          - name: WORKFLOW_CMD
            value: '{{workflow.parameters.cmd}}'
          - name: CORRELATION_ID
            value: '{{workflow.parameters.correlationId}}'
          - name: FROM
            value: '{{workflow.parameters.from}}'
          - name: WORKFLOW_TYPE
            value: CI
          - name: CSP
            value: '{{workflow.parameters.csp}}'
          - name: GIT_TOKEN
            valueFrom:
              secretKeyRef:
                name: platform-git-token
                key: token
          - name: ARM_CLIENT_ID
            valueFrom:
              secretKeyRef:
                name: platform-credentials-1
                key: ARM_CLIENT_ID
          - name: ARM_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
                name: platform-credentials-1
                key: ARM_CLIENT_SECRET
        volumeMounts:
          - name: workdir
            mountPath: /data/workflow

    - name: plan
      container:
        image: bnsfecpfndnonprodacr.azurecr.io/bnsf-infra-provisioner:v1.1
        command: [sh, '-ce']
        args:
          - source /data/workflow/response_msg/terraform_env.sh
            source /data/workflow/response_msg/dryrun.sh
        env:
          - name: ROOT_PATH
            value: '{{workflow.parameters.rootPath}}'
        volumeMounts:
          - name: workdir
            mountPath: /data/workflow

    - name: gates
      container:
        image: bnsfecpfndnonprodacr.azurecr.io/cloudops-workflow-step-cli:v2.16
        command: [bash, '-ce']
        args:
          - echo "Gates Successful"
        volumeMounts:
          - name: workdir
            mountPath: /data/workflow

    - name: cost
      container:
        image: bnsfecpfndnonprodacr.azurecr.io/cloudops-workflow-step-cli:v2.16
        command: [bash, '-ce']
        args:
          - echo "Cost Successful"
        volumeMounts:
          - name: workdir
            mountPath: /data/workflow

    - name: release
      container:
        image: bnsfecpfndnonprodacr.azurecr.io/cloudops-workflow-step-cli:v2.16
        command: [bash, '-ce']
        args:
          - cp /data/workflow/response_msg/bundle.json
            /data/workflow/main_repo/bundle.json
            . /data/workflow/response_msg/repo_env.sh
            ./cli-app.sh repoRelease
            ./cli-app.sh notify step=`Notify` level=success role=user
            "note=Email Notification of GitHub Repository Release"
        volumeMounts:
          - name: workdir
            mountPath: /data/workflow

    - name: apply
      container:
        image: bnsfecpfndnonprodacr.azurecr.io/bnsf-infra-provisioner:v1.1
        command: [sh, '-ce']
        args:
          - echo "Apply Successful"
        env:
          - name: ROOT_PATH
            value: '{{workflow.parameters.rootPath}}'
        volumeMounts:
          - name: workdir
            mountPath: /data/workflow

    - name: exit-handler
      container:
        image: bnsfecpfndnonprodacr.azurecr.io/cloudops-workflow-step-cli:v2.16
        command: [bash, '-ce']
        args:
          - ./cli-app.sh exitHandler workflowType=provisioning-ci
            attachedTypes=log,plan,apply workflowStatus='{{workflow.status}}'
        volumeMounts:
          - name: workdir
            mountPath: /data/workflow

  serviceAccountName: argo-foundation-sa
  volumeClaimTemplates:
    - metadata:
        name: workdir
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 1Gi
  onExit: exit-handler
  ttlStrategy:
    secondsAfterCompletion: 600
    secondsAfterSuccess: 600
    secondsAfterFailure: 600
  workflowMetadata:
    labels:
      type: resource-provisioning-workflow