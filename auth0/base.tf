terraform {
  required_version = "~> 0.12.24"
}

# don't bother setting up remote state for this subfolder;
# once it gets fixed promote this back up to the root folder and let it use that state
