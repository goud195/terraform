terraform/
├── main.tf           # Calls the lambda module
├── variables.tf      # Declares 'environment'
├── dev.tfvars        # env = "dev"
├── test.tfvars       # env = "test"
├── uat.tfvars        # env = "uat"
└── module/
    └── lambda/
        ├── main.tf       # IAM + Lambda creation here
        └── variables.tf  # policy lists + environment variable
