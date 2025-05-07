target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=alpine depName=nfs-utils versioning=apk
  default = "2.6.4-r3"
}

variable "RPCBIND_VERSION" {
  // renovate: datasource=alpine depName=rpcbind versioning=apk
  default = "1.2.7-r0"
}

variable "SOURCE" {
  default = "https://linux-nfs.org/"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
    RPCBIND_VERSION = "${RPCBIND_VERSION}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
