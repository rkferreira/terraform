# Shared TF env


## Requirements

*terraform version* >= `1.0.0`        [Download](https://www.terraform.io/downloads.html)

*aws cli*                             [Download](https://aws.amazon.com/cli/)



## Usage


### Code changes

```
## Clone repo code
git clone -b <GIT_BRANCH> <GIT_PROJECT>

## Create a new local branch
git checkout -b <YOUR_NEW_BRANCH>
```

Usually *GIT_BRANCH* is `main` or `master`.

*GIT_PROJECT* you copy it from Github -> <Repository> -> *Code* green button


*YOUR_NEW_BRANCH* has a good practice on prefixing it with:
- fix/<MEANING_BRANCH_NAME>
- ft/<MEANING_BRANCH_NAME>

*fix* for fixes
*ft*  for new features


After code changes:

- `terraform validate`
- `terraform fmt`
- `terraform plan -var-file=<ENV_NAME>.tfvars`

If its ok, then:

1. `git status`
2. `git add <CHANGED_FILES>`
3. `git commit -m "MEANING COMMIT MESSAGE"`
4. `git push origin <YOUR_NEW_BRANCH>`
5. Click on *Open Pull* request link that is showed, or go thru Github website
6. Pull request peer review
7. Merge
8. terraform apply from master branch


### Terraform run


These are temporary credentials, you must get it again from time to time.

Export it or use with credentials file/profile.


```
## Show workspaces
terraform workspace list

## Select the one you want to work on
terraform workspace select <WORKSPACE_NAME>

## Plan changes
terraform plan -var-file=<ENV_NAME>.tfvars

## Apply changes
terraform apply -var-file=<ENV_NAME>.tfvars

```

Little help, checking AWS cli caller, if you need to check:
```
aws sts get-caller-identity
```


