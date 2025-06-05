# Requirements

## Terraform
For Terraform installation, please follow the official installation guide at:
https://developer.hashicorp.com/terraform/install

## TFLint
TFLint is a Terraform linter that checks potential errors and enforces best practices. To install TFLint, refer to:
https://github.com/terraform-linters/tflint?tab=readme-ov-file#installation

### Installing sub modules
Then initialize the project's modules using `tflint --inint`

Note: If you encounter checksum verification failures during initialization (common when behind corporate VPNs or firewalls that perform TLS inspection), you'll need to install the modules manually. This happens because security tools may intercept and modify the downloaded files, causing the checksum to differ from expected values.
ref: https://github.com/terraform-linters/tflint-ruleset-aws/issues/174

# Set Git Hooks
To enable the pre-push Git hook for this repository, run the following commands:

```cmd
chmod +x ./.githooks/pre-push
git config --local core.hooksPath .githooks/
```

This configures Git to use the custom hooks in the .githooks directory and ensures the pre-push hook is executable.