target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=docker depName=ghcr.io/calibrain/calibre-web-automated-book-downloader
  default = "20250506@sha256:97a636efe3b78e1306ff521aa09256125aacdb1a04e628df294d7b6da3fe7b4a"
}

variable "SOURCE" {
  default = "https://github.com/calibrain/calibre-web-automated-book-downloader"
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
