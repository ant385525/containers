target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=custom.fileflows depName=fileflows versioning=loose
  default = "25.8.1.5789"
}

variable "FFMPEG_VERSION" {
  // renovate: datasource=deb depName=jellyfin-ffmpeg7 versioning=deb
  default = "7.1.1-7-noble"
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
