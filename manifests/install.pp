# The RENCI RPM packages contain overlapping files (especially the
# icommands) so we have to try to ensure only one core package is
# installed at at time - handling cases, for example, when an
# irods::client is changed to irods::resource.
define irods::install (
  $packages = undef,
  $core_version  = $irods::params::core_version
) {

  if is_array($packages) {
    $install_pkgs = $packages
  } else {
    $install_pkgs = [$packages]
  }

  case $::osfamily {
    'RedHat': {
      $core_packages = $irods::params::core_packages
      $rm_pkgs = difference($core_packages, $install_pkgs)
    }
    default: {
      $rm_pkgs = []
    }
  }

  package { $rm_pkgs:
    ensure => absent,
  } ->
  package { $install_pkgs:
    ensure => $core_version,
  }

}
