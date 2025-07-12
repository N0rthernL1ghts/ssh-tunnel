group "default" {
  targets = [
    "latest",
  ]
}

target "build-dockerfile" {
  dockerfile = "Dockerfile"
}

target "build-platforms" {
  platforms = ["linux/amd64", "linux/aarch64"]
}

target "build-common" {
  pull = true
}

######################
# Define the variables
######################

variable "REGISTRY_CACHE" {
  default = "docker.io/nlss/ssh-tunnel-cache"
}

######################
# Define the functions
######################

# Get the arguments for the build
function "get-args" {
  params = [version]
  result = {
    ALPINE_VERSION = version
  }
}

# Get the cache-from configuration
function "get-cache-from" {
  params = [version]
  result = [
    "type=registry,ref=${REGISTRY_CACHE}:${sha1("${version}-${BAKE_LOCAL_PLATFORM}")}"
  ]
}

# Get the cache-to configuration
function "get-cache-to" {
  params = [version]
  result = [
    "type=registry,mode=max,ref=${REGISTRY_CACHE}:${sha1("${version}-${BAKE_LOCAL_PLATFORM}")}"
  ]
}

# Get list of image tags and registries
# Takes a version and a list of extra versions to tag
# eg. get-tags("3.17", ["3.17.2", "latest"])
function "get-tags" {
  params = [version, extra_versions]
  result = concat(
    [
      "docker.io/nlss/ssh-tunnel:${version}",
      "ghcr.io/n0rthernl1ghts/ssh-tunnel:${version}"
    ],
    flatten([
      for extra_version in extra_versions : [
        "docker.io/nlss/ssh-tunnel:${extra_version}",
        "ghcr.io/n0rthernl1ghts/ssh-tunnel:${extra_version}"
      ]
    ])
  )
}

##########################
# Define the build targets
##########################

target "latest" {
  inherits   = ["build-dockerfile", "build-platforms", "build-common"]
  cache-from = get-cache-from("latest")
  cache-to   = get-cache-to("latest")
  tags       = get-tags("latest", [])
  args       = get-args("3.17")
}

