target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=custom.fileflows depName=fileflows versioning=loose
  default = "25.5.3.5468"
}

variable "FFMPEG_VERSION" {
  // renovate: datasource=deb depName=jellyfin-ffmpeg7 versioning=deb
  default = "7.1.1-3-noble"
}

variable "INTEL_CR_VERSION" {
  // renovate: datasource=github-releases depName=intel/compute-runtime
  default = "25.18.33578.6"
}

variable "SOURCE" {
  default = "https://github.com/revenz/fileflows"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
    FFMPEG_VERSION = "${FFMPEG_VERSION}"
    INTEL_CR_VERSION = "${INTEL_CR_VERSION}"
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
