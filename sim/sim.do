dump -add /*
setenv TIMEOUT 100us
stop -absolute $env(TIMEOUT) -command {
  echo "ERROR: timeout_error at $now"
  if {[info command guiIsActive]==""} {
    quit
  }
}
run