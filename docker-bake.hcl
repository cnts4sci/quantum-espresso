group "default" {
    targets = ["qe"]
}

variable "ORGANIZATION" {
    default = "cnts4sci"
}

variable "VERSION" {
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
        build-base-image = "docker-image://ghcr.io/cnts4sci/bm:2024.1001"
        runtime-base-image = "docker-image://docker.io/phusion/baseimage:focal-1.2.0"
        openmpi-builder-image = "docker-image://ghcr.io/cnts4sci/bm-openmpi:v4.1.6"
        lapack-builder-image = "docker-image://ghcr.io/cnts4sci/bm-lapack:v3.10.1"
    }
    args = {
      "QE_VERSION" = "${VERSION}"
    }
}

