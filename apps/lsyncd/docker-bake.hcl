target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=alpine depName=lsyncd versioning=apk
  default = "2.3.1-r1"
}

variable "SOURCE" {
  default = "https://github.com/lsyncd/lsyncd"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
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
