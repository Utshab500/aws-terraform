# AWS Terraform Assets
This project is for learning purpose, here <b>AWS infrastructure</b> use cases are developed.
## Purpose
This project serves the following purposes:
- Working on infrastructure use cases, basic to advance.
- Building a <i>learning asset</i> which helps learning and understanding of `terraform` fundamentals

# How to work in this repository
The primary asset here in this repo is the `modules` folder. I try to develop reusable modules in this folder so that they can be used in the `use-cases`.
### Writing a module
Reusable module comes with `variables` and `output`. Hence to simplyfy the module creation execute below command.
```bash
# Generate reusable module structure
chmod +x generate-module-structure.sh
./generate-module-structure.sh <module-name>
```
This will generate below module structure
```
# Modules folder structure
<module-name>
├── main.tf
├── outputs.tf
└── variables.tf
```
> <b>Note:</b> Always include `defult` value in variables file to avoide any unintended broken terraform script. 