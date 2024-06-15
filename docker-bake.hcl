group "default" {
    targets = ["mpich"]
}

variable "ORGANIZATION" {
    default = "cnts4sci"
}

variable "BULID_BASE_IMAGE" {
}

variable "RUNTIME_BASE_IMAGE" {
}

variable "QE_VERSION" {
}

variable "REGISTRY" {
    default = "ghcr.io"
}

function "tags" {
  params = [image]
  result = [
    "${REGISTRY}/${ORGANIZATION}/${image}",
  ]
}

target "mpich-meta" {
    tags = tags("quantum-espresso")
}

target "mpich" {
    inherits = ["mpich-meta"]
    context = "."
    contexts = {
        build-base-image = "docker-image://${BUILD_BASE_IMAGE}"
        runtime-base-image = "docker-image://${RUNTIME_BASE_IMAGE}"
    }
    args = {
        "QE_VERSION" = "${QE_VERSION}"
    }
}
