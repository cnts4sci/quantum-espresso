group "default" {
    targets = ["qe"]
}

variable "ORGANIZATION" {
    default = "cnts4sci"
}

variable "BULID_BASE_IMAGE" {
}

variable "RUNTIME_BASE_IMAGE" {
}

variable "OPENMPI_BUILDER" {
}

variable "LAPACK_BUILDER" {
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

target "qe-meta" {
    tags = tags("quantum-espresso")
}

target "qe" {
    inherits = ["qe-meta"]
    context = "."
    contexts = {
        build-base-image = "docker-image://${BUILD_BASE_IMAGE}"
        runtime-base-image = "docker-image://${RUNTIME_BASE_IMAGE}"
        openmpi-builder-image = "docker-image://${OPENMPI_BUILDER}"
        lapack-builder-image = "docker-image://${LAPACK_BUILDER}"
    }
    args = {
      "QE_VERSION" = "${QE_VERSION}"
    }
}

