local SOURCE = os.getenv("SOURCE")
local TARGET = os.getenv("TARGET")

settings {
  nodaemon       = "true",
  logfile        = "/dev/stdout",
  statusFile     = "/dev/stdout",
  statusInterval = 20,
}

sync {
  default.rsync,
  source    = SOURCE,
  target    = TARGET,
  delay     = 5,
  rsync     = {
    archive = true,
    verbose = true,
  }
}
