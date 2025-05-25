target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=github-releases depName=crocodilestick/Calibre-Web-Automated
  default = "3.0.4"
}

variable "SOURCE" {
  default = "https://github.com/crocodilestick/Calibre-Web-Automated"
}

variable "SUPERCRONIC_VERSION" {
  // renovate: datasource=github-releases depName=aptible/supercronic
  default = "v0.2.33"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}",
    SUPERCRONIC_VERSION = "${SUPERCRONIC_VERSION}"
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
